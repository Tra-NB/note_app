import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../shared/error/failures.dart';

class NoteRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<Either<Failures, List<Map<String,dynamic>>>> getNotes() async{
    try{
      final snapshot = await _firebaseFirestore.collection('notes').get();
      final notes = snapshot.docs.map((doc) => doc.data()).toList();

      return right(notes);
    }catch(err){
      return left(FirebaseFailure("Lỗi: $err"));
    }
  }
}