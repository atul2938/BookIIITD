class TimeSlots{
  
  int startTime;    //HHMM format, eg 1915
  int endTime;      //HHMM format
  String day;       
  String purpose;   //eg. Class

  TimeSlots(startTime, endTime, day, purpose)
  {
    this.startTime = startTime;
    this.endTime   = endTime;
    this.day       = day;
    this.purpose   = purpose;
  }
}