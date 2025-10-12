import 'package:firebase_auth/firebase_auth.dart';

String mapFirebaseAuthError(FirebaseAuthException error) {
  switch (error.code) {
    case 'email-already-in-use':
      return 'このメールアドレスはすでに登録済みです。ログインに切り替えて試してください。';
    case 'invalid-email':
      return 'メールアドレスの形式が正しくありません。';
    case 'user-not-found':
      return '入力されたメールアドレスにはアカウントが存在しません。';
    case 'wrong-password':
    case 'invalid-login-credentials':
      return 'メールアドレスまたはパスワードが誤っています。';
    case 'too-many-requests':
      return '操作が集中しています。時間をおいて再度お試しください。';
    case 'network-request-failed':
      return '通信に失敗しました。ネットワーク環境を確認してください。';
    case 'invalid-credential':
    case 'credential-already-in-use':
      return '認証情報が無効です。もう一度ログインし直してください。';
    case 'user-disabled':
      return 'このアカウントは利用できません。管理者にお問い合わせください。';
    case 'requires-recent-login':
      return '安全のため再度ログインが必要です。いったんサインアウトしてログインし直してください。';
    default:
      return '処理に失敗しました (${error.code}). 時間を置いてからもう一度お試しください。';
  }
}
