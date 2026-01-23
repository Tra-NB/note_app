abstract class Failures {
  final String message;
  Failures(this.message);

}

class FirebaseFailure extends Failures{
  FirebaseFailure (super.message);
  
}

class NoteFailure extends Failures{
  NoteFailure(super.message);
}