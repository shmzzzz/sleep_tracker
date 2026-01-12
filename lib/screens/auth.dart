import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sleep_tracker/utils/firebase_errors.dart';
import 'package:sleep_tracker/utils/context_extensions.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  // ログイン状態を管理するフラグ
  var _isLogin = true;
  // 認証処理の通信状態を管理するフラグ
  var _isAuthenticating = false;
  // 入力されたメールアドレス
  var _enteredEmail = '';
  // 入力されたパスワード
  var _enteredPassword = '';
  var _obscurePassword = true;

  // ログイン処理を行うメソッド
  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();

    // currentStateがvalidate出ない場合は処理を行わない
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();

    try {
      // このブロックに入る=認証処理を行う必要があるのでtrue
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        // ログインしている場合の処理
        await _login();
      } else {
        await _createUserAndLogin();
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      await _handleAuthError(error);
      if (!mounted) return;
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  Future<void> _login() async {
    await _firebase.signInWithEmailAndPassword(
      email: _enteredEmail,
      password: _enteredPassword,
    );
  }

  Future<void> _createUserAndLogin() async {
    final userCredentails = await _firebase.createUserWithEmailAndPassword(
      email: _enteredEmail,
      password: _enteredPassword,
    );
    // Firestoreへ登録する
    await FirebaseFirestore.instance
        .collection('users') // コレクションID(テーブル名的な)
        .doc(userCredentails
            .user!.uid) // ドキュメントID << usersコレクション内のドキュメント(ユニークなものだったら何でも良い？)
        .set({
      // データを設定する
      'username': 'to be done...',
      'email': _enteredEmail,
    });
  }

  Future<void> _handleAuthError(FirebaseAuthException error) async {
    final code = error.code;
    final fallbackMessage = mapFirebaseAuthError(error);

    switch (code) {
      case 'user-not-found':
        await context.showErrorDialog(
          title: 'アカウントが見つかりません',
          message: '入力されたメールアドレスにはアカウントが登録されていません。新しく作成しますか？',
          actionsBuilder: (dialogContext) => [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('閉じる'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _isLogin = false;
                });
              },
              child: const Text('新規登録へ'),
            ),
          ],
        );
        break;
      case 'email-already-in-use':
        await context.showErrorDialog(
          title: 'すでに登録済みです',
          message: fallbackMessage,
          actionsBuilder: (dialogContext) => [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('閉じる'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _isLogin = true;
                });
              },
              child: const Text('ログインに切り替える'),
            ),
          ],
        );
        break;
      case 'wrong-password':
      case 'invalid-login-credentials':
        await context.showErrorDialog(
          title: 'ログインに失敗しました',
          message: fallbackMessage,
        );
        break;
      case 'network-request-failed':
        await context.showErrorDialog(
          title: '通信エラー',
          message: 'インターネット接続を確認してから、もう一度お試しください。',
        );
        break;
      case 'too-many-requests':
        await context.showErrorDialog(
          title: 'しばらくお待ちください',
          message: '短時間にリクエストが集中しました。時間を置いて再実行してください。',
        );
        break;
      default:
        await context.showErrorDialog(
          title: 'エラーが発生しました',
          message: fallbackMessage,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    Icons.bedtime_rounded,
                    size: 36,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Sleep Tracker',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ヘルスケアに特化した睡眠トラッカーで、日々のリズムを整えましょう。',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: colorScheme.outlineVariant),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AnimatedOpacity(
                          opacity: _isAuthenticating ? 1 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: _isAuthenticating
                              ? const LinearProgressIndicator()
                              : const SizedBox.shrink(),
                        ),
                        if (_isAuthenticating) const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('メールアドレス'),
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'メールアドレスを入力してください。';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredEmail = newValue!;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            label: const Text('パスワード'),
                            prefixIcon: const Icon(Icons.key),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'パスワードを6文字以上で入力してください。';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredPassword = newValue!;
                          },
                          onFieldSubmitted: (_) {
                            if (!_isAuthenticating) {
                              _submit();
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _isAuthenticating ? null : _submit,
                          icon: Icon(
                            _isLogin ? Icons.login : Icons.person_add_alt_1,
                          ),
                          label: Text(_isLogin ? 'ログイン' : 'アカウント作成'),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _isAuthenticating
                              ? null
                              : () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                          child: Text(
                            _isLogin ? 'アカウント新規作成はこちら' : 'ログインへ戻る',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
