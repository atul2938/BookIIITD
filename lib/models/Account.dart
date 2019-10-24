class Account {
  String name;
  String emailId;
  String role;
  int privilege;

  Account(name,emailId,role){
    this.name=name;
    this.emailId=emailId;
    this.role=role;
    if(role=='Administration')
      {
        this.privilege=3;
      }
    else
      {
        this.privilege =1;
      }
  }
}