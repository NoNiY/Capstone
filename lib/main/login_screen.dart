import 'package:flutter/material.dart';
import 'package:untitled1/config/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled1/main/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/main/main_screen.dart';



class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool isTyping = false;
  bool isSignupScreen = true;
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';
  bool _obscureText = true;
  final TextEditingController _textController =
  TextEditingController(); // 이 부분에 추가
  final FocusNode _userNameFocus = FocusNode();

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  void dispose() {
    _textController.dispose(); // 사용이 끝난 후에는 해제해주어야 합니다.
    _userNameFocus.dispose();
    super.dispose();
  }

  void _resetTyping() {
    setState(() {
      isTyping = false;
    });
  }
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Palette.backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          _resetTyping();
        },
        child: Stack(
          children: [
            Positioned.fill(
              top: -040,
              child: Image.asset(
                'assets/images/login_back.png', // 이미지 파일 경로로 수정하세요.
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 90, left: 85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: isSignupScreen
                                ? 'My Character Planer'
                                : 'My Character Planer',
                            style: const TextStyle(
                              letterSpacing: 0.0,
                              fontSize: 30,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontFamily: "continuous",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: isTyping ? 300 : 500,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
                padding: const EdgeInsets.all(20.0),
                height: isSignupScreen ? 400.0 : 350.0,
                width: MediaQuery.of(context).size.width - 40,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = false;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  '로그인',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1,
                                  ),
                                ),
                                if (!isSignupScreen)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = true;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  '회원가입',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1,
                                  ),
                                ),
                                if (isSignupScreen)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isSignupScreen)
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _textController, // 수정된 부분
                                  focusNode: _userNameFocus,
                                  key: const ValueKey(1),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 4) {
                                      return 'Please enter at least 4 characters';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    userName = value!;
                                  },
                                  onTap: () {
                                    setState(() {
                                      isTyping = true;
                                    });
                                  },
                                  onChanged: (value) {
                                    userName = value;
                                  },
                                  onFieldSubmitted: (value) {
                                    _resetTyping();
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    hintText: 'User name',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  key: const ValueKey(2),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains('@')) {
                                      return 'Please enter a valid email address.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    userEmail = value!;
                                  },
                                  onTap: () {
                                    setState(() {
                                      isTyping = true;
                                    });
                                  },
                                  onChanged: (value) {
                                    userEmail = value;
                                  },
                                  onFieldSubmitted: (value) {
                                    _resetTyping();
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    hintText: 'email',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  obscureText: true, // 이 부분을 수정함
                                  key: const ValueKey(3),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      return 'Password must be at least 7 characters long.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    userPassword = value!;
                                  },
                                  onTap: () {
                                    setState(() {
                                      isTyping = true;
                                    });
                                  },
                                  onChanged: (value) {
                                    userPassword = value;
                                  },
                                  onFieldSubmitted: (value) {
                                    _resetTyping();
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    hintText: 'password',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (!isSignupScreen)
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: const ValueKey(4),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains('@')) {
                                      return '올바른 이메일을 입력해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    userEmail = value!;
                                  },
                                  onTap: () {
                                    setState(() {
                                      isTyping = true;
                                    });
                                  },
                                  onChanged: (value) {
                                    userEmail = value;
                                  },
                                  onFieldSubmitted: (value) {
                                    _resetTyping();
                                  },
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    hintText: 'email',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                TextFormField(
                                  obscureText: true, // 이 부분을 수정함
                                  key: const ValueKey(5),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      return '올바른 비밀번호를 입력해주세요.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    userPassword = value!;
                                  },
                                  onTap: () {
                                    setState(() {
                                      isTyping = true;
                                    });
                                  },
                                  onChanged: (value) {
                                    userPassword = value;
                                  },
                                  onFieldSubmitted: (value) {
                                    _resetTyping();
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Palette.iconColor,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off), // 눈 아이콘 토글
                                      onPressed: _togglePasswordVisibility, // 토글 함수 호출
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Palette.textColor1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                    ),
                                    hintText: 'password',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,

                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        top: isSignupScreen ? 790 : 790,
                        right: 0,
                        left: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                if (isSignupScreen) {
                                  _tryValidation();

                                  try {
                                    final newUser = await _authentication
                                        .createUserWithEmailAndPassword(
                                      email: userEmail,
                                      password: userPassword,
                                    );
                                    await _firestore
                                        .collection('users')
                                        .doc(newUser.user!.uid)
                                        .set({
                                      'email': userEmail,
                                      'name': userName, // 사용자 이름 추가
                                      'points': 0,
                                      'exp':0,
                                    });
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const HomePage(),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print(e);
                                    _showErrorDialog('아이디 혹은 비밀번호가 잘못되었습니다');
                                  }
                                }
                                if (!isSignupScreen) {
                                  _tryValidation();
                                  try {
                                    final newUser = await _authentication
                                        .signInWithEmailAndPassword(
                                      email: userEmail,
                                      password: userPassword,
                                    );
                                    if (newUser.user != null) {
                                      if (context.mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const HomePage();
                                            },
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    print(e);
                                    _showErrorDialog('아이디 혹은 비밀번호가 잘못되었습니다');
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Image.asset(
                                  'assets/images/arrow.png', // 이미지 파일 경로로 수정하세요.
                                  fit: BoxFit.cover,
                                  height: 24, // 이미지의 높이를 조정합니다.
                                  width: 24, // 이미지의 너비를 조정합니다.
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        top: isSignupScreen
                            ? MediaQuery.of(context).size.height - 100
                            : MediaQuery.of(context).size.height - 95,
                        right: 0,
                        left: 0,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                try {
                                  final userCredential = await _authentication.signInWithPopup(GoogleAuthProvider());
                                  final user = userCredential.user;
                                  if (user != null) {
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HomePage()),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  _showErrorDialog(e.toString());
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                minimumSize: const Size(155, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(color: Colors.black),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              icon: Image.asset(
                                'assets/images/google.png', // 주어진 이미지 파일 경로로 변경
                                width: 24, // 이미지의 너비 조정
                                height: 24, // 이미지의 높이 조정
                              ),
                              label: const Text('Google'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}