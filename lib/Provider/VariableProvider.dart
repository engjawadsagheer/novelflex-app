 import 'package:flutter/material.dart';

class VariableProvider extends ChangeNotifier{
 bool _reviewflag = false;
 bool _isloading = false;
 int _like =0;
 int _dislikes =0;

 int _commentLikes =0;


 bool reviewFlag() => _reviewflag;
 bool loadingFlag() => _isloading;

 int get getLikes => _like;
 int get getCommentLikes => _commentLikes;
 int get getDislikes => _dislikes;


 //method to get update value of variable
 updateReview(bool flagR){
  _reviewflag =flagR ;  //method to update the variable value
  notifyListeners();
 }

 updateLoader(bool flagL){
  _isloading =flagL ;  //method to update the variable value
  notifyListeners();
 }

 setLikes(int flagR){
  _like =flagR ;  //method to update the variable value
  notifyListeners();
 }

 setCommentLikes(int flagR){
  _commentLikes =flagR ;  //method to update the variable value
  notifyListeners();
 }

 setDislikes(int flagR){
  _dislikes =flagR ;  //method to update the variable value
  notifyListeners();
 }



 }