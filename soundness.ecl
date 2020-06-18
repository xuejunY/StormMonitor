
/*
 *  @desc   ECL rules for specifying soundess of Storm 
 *  @author   FAIR
 *  @time   5/17/2020
*/


/*
 *  PART 1.  Event PART
 */
case_attr "mid" : string ;

event semit = {"SEMIT", [ "id":string,        /* event id */   
                           "mid":string,      /*  source tuple id */ 
                           "sid":string,      /*  stream id       */
                           "en":string,       /*  event name   */
                           "cid":string,      /*  componet id */
                           "time":int         /*  time   */
                         ]  } ;

event take = {"TAKE", [ "id":string,        /* event id */   
						"mid":string,      /*  source tuple id */ 
						"sid":string,      /*  stream id       */
						"tid":string,      /*  read tuple id   */
						"en":string,       /*  event name   */
						"cid":string,      /*  componet id */
						"time":int         /*  time   */
						]  } ;

event emit = {"EMIT", [ "id":string,        /* event id */   
						"mid":string,      /*  source tuple id */ 
						"sid":string,      /*  stream id       */
						"tid":string,      /*  read tuple id   */
						"en":string,       /*  event name   */
						"cid":string,      /*  componet id */
						"time":int         /*  time   */
						]  } ;

event ack = {"ACK", [   "id":string,        /* event id */   
						"mid":string,      /*  source tuple id */ 
						"tid":string,      /*  read tuple id   */
						"en":string,       /*  event name   */
						"cid":string,      /*  componet id */
						"time":int         /*  time   */
						]  } ;

event fail = {"FAIL", [ "id":string,        /* event id */   
						"mid":string,      /*  source tuple id */ 
						"tid":string,      /*  read tuple id   */
						"en":string,       /*  event name   */
						"cid":string,      /*  componet id */
						"time":int         /*  time   */
						]  } ;

event sAck = {"SACK", [ "id":string,        /* event id */   
						"mid":string,      /*  source tuple id */ 
						"en":string,       /*  event name   */
						"time":int         /*  time   */
						]  } ;

event sFail = {"SFAIL", [ "id":string,        /* event id */   
						"mid":string,      /*  source tuple id */ 
						"en":string,       /*  event name   */
						"time":int         /*  time   */
						]  } ;

/*  
 *  PART 2. Policies Part
 *  The soundess of Storm computing could be specified by :
     SOUNDNESS = ST  && NSB && TAF  &&  ET, 
                  where, 
     Stop(ST):  each tuple after semit needs to be sAck or sFail.
     NoSACKORFAILBefore (NSB): for each tuple, it must not be sAcked or sFailed before other events.
     TakeItACKORFAIL (TAF): for each bolt, each tuple it taken must be acked or failed.
     EmitToTake (ET): for each tuple, after emited, it must be taken by one bolt.
 */
		
/* r1*/
 rule ST = always after(_, semit, sAck, semit.mid=sAck.mid)  
                  | 
                  after(_, semit, sFail, semit.mid=sFail.mid) ;

/* r2*/
rule NSBsemit = always before(_, ors(sAck), semit, semit.mid=ors(sAck).mid)
                       &
                      before(_, ors(sFail), semit, semit.mid=ors(sFail).mid) ;

/* r3*/
rule NSBtake = always before(_, ors(sAck), take, take.mid=ors(sAck).mid)
                     &
                     before(_, ors(sFail), take, take.mid=ors(sFail).mid) ;

/* r4*/
rule NSBemit = always before(_, ors(sAck), emit, emit.mid=ors(sAck).mid)
                     &
                     before(_, ors(sFail), emit, emit.mid=ors(sFail).mid) ;

/* r5*/
rule NSBack = always before(_, ors(sAck), ack, ack.mid=ors(sAck).mid)
                     &
                     before(_, ors(sFail), ack, ack.mid=ors(sFail).mid) ;

/* r6*/                     
rule NSBfail = always before(_, ors(sAck), fail, fail.mid=ors(sAck).mid)
                     &
                     before(_, ors(sFail), fail, fail.mid=ors(sFail).mid) ;

/* r7*/
rule NSBsAck = always before(_, ors(sFail), sAck, sAck.mid=ors(sFail).mid) ;

/* r8 */                   
rule NSBsFail = always before(_, ors(sAck), sFail, sFail.mid=ors(sAck).mid) ;

/* r9 */
rule TAF =  always after(_, take, ack, take.tid=ack.tid && take.cid=ack.cid)
                    |
                    after(_, take, fail, take.tid=fail.tid && take.cid=fail.cid) ;

 /* r10 */
 rule ETemit = always after(_, emit, take, 
                                     emit.tid=take.tid && emit.sid=take.sid) ;

 /* r11 */
 rule ETsemit = always after(_, semit, take, 
                                      semit.tid=take.tid && semit.sid=take.sid) ;
               


/*  ---    End of specifiction   ----   */
