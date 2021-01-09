import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:zeroday/bloc/homeBloc/home_event.dart';
import 'package:zeroday/bloc/homeBloc/home_state.dart';
import 'package:zeroday/repositories/user_repository.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  UserRepository userRepository;

  HomePageBloc({@required UserRepository userRepository}) : super(null) {
    this.userRepository = userRepository;
  }

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if (event is LogOutEvent) {
      print("LOG out Bloc");
      userRepository.signOut();
      yield LogOutSuccessState();
    }
  }
}
