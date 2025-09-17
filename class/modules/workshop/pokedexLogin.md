


![login.png](images/login/login.png)
![signup.png](images/login/signup.png)

## Task 1: Create LoginScreen
login_screen.dart
```dart
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TODO ADD COMPONENT
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

## Result
![first.png](images/login/first.png)

---

## Task 1: Add Header UI
![second_intro.png](images/login/second_intro.png)


### 1.1 Create LoginHeader Widget
login_header.dart
```dart
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildTitle(),
        const SizedBox(height: 30),
        _buildImage(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Welcome To',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Pokedex',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFC107), // Pokemon yellow
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.catching_pokemon,
              size: 80,
              color: Color(0xFFFFC107),
            ),
          ),
        ),
      ),
    );
  }
}
```

### 1.2 Add LoginHeader in Login_screen.dart
```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoginHeader(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
```


## 1.3.Result 
![second.png](images/login/second.png)

---

## Task 2 Add Login Form (Email & Password)
![third_intro.png](images/login/third_intro.png)

### 2.1 Create LoginForm Widget
login_form.dart
```dart
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final bool isLoginMode;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final Function(String email) onLoginSuccess;
  final Function(String email) onSignUpSuccess;

  const LoginForm({
    super.key,
    required this.isLoginMode,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onLoginSuccess,
    required this.onSignUpSuccess,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            widget.isLoginMode ? 'Login' : 'Sign Up',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFC107),
            ),
          ),
          const SizedBox(height: 24),
          if (widget.isLoginMode) _buildLoginForm() else _buildSignUpForm(),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          // Email Field
          _buildEmailField(),

          const SizedBox(height: 16),

          // Password Field
          _buildPasswordField(
            widget.passwordController,
            'Password',
            _isPasswordVisible,
            () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),

          const SizedBox(height: 24),

          // Login Button
          _buildActionButton('Login', _handleLogin),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: signupFormKey,
      child: Column(
        children: [
          // Email Field
          _buildEmailField(),

          const SizedBox(height: 16),

          // Password Field
          _buildPasswordField(
            widget.passwordController,
            'Password',
            _isPasswordVisible,
            () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),

          const SizedBox(height: 16),

          _buildPasswordField(
            widget.confirmPasswordController,
            'Confirm Password',
            _isConfirmPasswordVisible,
            () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
            isConfirmPassword: true,
          ),

          const SizedBox(height: 24),

          _buildActionButton('Sign Up', _handleSignUp),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: widget.emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: const Icon(Icons.email, color: Color(0xFFFFC107)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFC107), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    bool isVisible,
    VoidCallback toggleVisibility, {
    bool isConfirmPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: const Icon(Icons.lock, color: Color(0xFFFFC107)),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white.withOpacity(0.7),
          ),
          onPressed: toggleVisibility,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFC107), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        if (isConfirmPassword && value != widget.passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC107),
          foregroundColor: Colors.black,
          elevation: 4,
          shadowColor: const Color(0xFFFFC107).withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (loginFormKey.currentState!.validate()) {
      widget.onLoginSuccess(widget.emailController.text);
    }
  }

  void _handleSignUp() {
    if (signupFormKey.currentState!.validate()) {
      widget.onSignUpSuccess(widget.emailController.text);
    }
  }
}
```

### 2.2 Add LoginForm in Login_screen.dart

```dart
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoginMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  -- LoginHeader --
                  LoginForm(
                    isLoginMode: _isLoginMode,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    onLoginSuccess: _handleLoginSuccess,
                    onSignUpSuccess: _handleSignUpSuccess,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

void _handleLoginSuccess(String email) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Login: $email'),
      backgroundColor: const Color(0xFFFFC107),
      behavior: SnackBarBehavior.floating,
    ),
  );
  Navigator.pushReplacementNamed(context, Routes.pokemonList);
}

void _handleSignUpSuccess(String email) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Sign Up: $email'),
      backgroundColor: const Color(0xFFFFC107),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
```

### 2.3 Result
![third.png](images/login/third.png)


---

#### Task 3: Create the bottom part of login [Toggle Login & Signup]
![fourth_intro1.png](images/login/fourth_intro1.png)
![fourth_intro2.png](images/login/fourth_intro2.png)

### 3.1 Create LoginBottom widget
login_bottom.dart
```dart
import 'package:flutter/material.dart';

class LoginBottom extends StatelessWidget {
  final bool isLoginMode;
  final VoidCallback onToggleMode;

  const LoginBottom({
    super.key,
    required this.isLoginMode,
    required this.onToggleMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLoginMode
              ? "Don't have an account? "
              : "Already have an account? ",
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
        ),
        TextButton(
          onPressed: onToggleMode,
          child: Text(
            isLoginMode ? 'Sign Up' : 'Login',
            style: const TextStyle(
              color: Color(0xFFFFC107),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
```

### 3.2 Login Bottom
```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  -- LoginHeader --
                  -- LoginForm --
                  const SizedBox(height: 30),
                  LoginBottom(
                    isLoginMode: _isLoginMode,
                    onToggleMode: _toggleMode,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

void _toggleMode() {
  setState(() {
    _isLoginMode = !_isLoginMode;
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  });

  _animationController.reset();
  _animationController.forward();
}
```

### 3.3 Result
![fourth.png](images/login/fourth.png)

---

### Cosmetic & Decorate
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A1B2E), Color(0xFF16213E), Color(0xFF0F3460)],
            ),
          ),
          child: SafeArea(
              child: SingleChildScrollView(
```

### Result
![login.png](images/login/login.png)


---

### Animation

```dart
class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
}
```

```dart

@override
void initState() {
  super.initState();
  _animationController = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  );
  _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
  );
  _animationController.forward();
}
```

### Wrap LoginForm with FadeTransition in LoginScreen

```dart
FadeTransition(
    opacity: _fadeAnimation,
    child: LoginForm(
      isLoginMode: _isLoginMode,
      emailController: _emailController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      onLoginSuccess: _handleLoginSuccess,
      onSignUpSuccess: _handleSignUpSuccess,
    ),
),
```

### Dispose
```dart
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
```