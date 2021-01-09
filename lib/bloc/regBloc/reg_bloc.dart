import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:zeroday/bloc/regBloc/reg_event.dart';
import 'package:zeroday/bloc/regBloc/reg_state.dart';
import 'package:zeroday/repositories/user_repository.dart';

class UserRegBloc extends Bloc<UserRegEvent, UserRegState> {
  UserRepository userRepository;

  UserRegBloc({@required UserRepository userRepository}) : super(null) {
    this.userRepository = userRepository;
  }

  @override
  UserRegState get initialState => UserRegInitial();

  @override
  Stream<UserRegState> mapEventToState(UserRegEvent event) async* {
    if (event is SignUpButtonPressed) {
      yield UserRegLoading();
      try {
        var user = await userRepository.signUpUserWithEmailPass(
            event.email, event.password);
        print("BLoC : ${user.email}");
        yield UserRegSuccessful();
        userRepository.signOut();
      } catch (e) {
        yield UserRegFailure(e.toString());
      }
    }
  }
}
