# wordCount
The file explains as follows:  
  1. The jar "core-1.3.1-SNAPSHOT.jar" is bpCMon engine, before we start the experiment, run the jar on the cmd.  
  2. The file "logs.zip" contains log with normal and abnormal type.  
  3. The file "results.zip" contains response results that bpCMon engine in terms of logs.  
  4. THe file "soundness.ecl" is soundness description of storm topology using ecl language.  
  5. The file "demo video" is about how to do reliability monitoring.

attention:we should use interface test tool , for example, post man, to commit log and soundness.ecl to bpCMon.
About log,there exist some traces first print but delay to write in log file.it will be result some problems,
such as "TAF" type error that bpCMon engine report,but we did not add "TAF" error in the log.Through response by bpCMon
engine we can inspect this error.
