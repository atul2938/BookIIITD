class Account {
  String name;
  String email_id;
  String role;
  int privilage;

  Account(name,email_id,role){
    this.name=name;
    this.email_id=email_id;
    this.role=role;
    if(role=='Administration')
      {
        privilage=3;
      }
    else
      {
        privilage =1;
      }
  }
}