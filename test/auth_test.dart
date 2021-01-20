import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_flutter/services/auth.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
}

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final Auth auth = Auth(auth: mockFirebaseAuth);

  setUp(() {});
  tearDown(() {});

  test("emit occurs", () async {
    expectLater(auth.user, emitsInOrder([_mockUser]));
  });

  test("create account", () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: "jarjit@spam4.me",
      password: "jarjit123!@#",
    )).thenAnswer((realInvocation) => null);

    expect(
        await auth.createAccount(
          email: "jarjit@spam4.me",
          password: "jarjit123!@#",
        ),
        "Success");
  });

  test("create account exception", () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "jarjit@spam4.me", password: "jarjit123!@#"))
        .thenAnswer(
      (realInvocation) => throw FirebaseAuthException(
        message: "User already registered!",
        code: null,
      ),
    );

    expect(
        await auth.createAccount(
          email: "jarjit@spam4.me",
          password: "jarjit123!@#",
        ),
        "User already registered!");
  });

  test("sign in acount", () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: "jarjit@spam4.me", password: "jarjit123!@#"))
        .thenAnswer((realInvocation) => null);

    expect(
        await auth.signIn(
          email: "jarjit@spam4.me",
          password: "jarjit123!@#",
        ),
        "Success");
  });

  test("sign in account exception", () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: "jarjit@spam4.me", password: "jarjit123!@#"))
        .thenAnswer((realInvocation) => throw FirebaseAuthException(
            message: "User doesnt registered!", code: null));

    expect(
        await auth.signIn(email: "jarjit@spam4.me", password: "jarjit123!@#"),
        "User doesnt registered!");
  });

  test("sign out account", () async {
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) => null);
    expect(await auth.signOut(), "Success");
  });

  test("sign out account exception", () async {
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) =>
        throw FirebaseAuthException(
            code: null, message: "Oops something went wrong!"));
    expect(await auth.signOut(), "Oops something went wrong!");
  });
}
