// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'auth_config.dart';
//
// // **************************************************************************
// // CopyWithGenerator
// // **************************************************************************
//
// abstract class _$AuthConfigCWProxy {
//   /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
//   ///
//   /// Usage
//   /// ```dart
//   /// AuthConfig(...).copyWith(id: 12, name: "My name")
//   /// ````
//   AuthConfig call({
//     String? androidSdk,
//     AuthUIConfig? authUIConfig,
//     AuthUIStyle? authUIStyle,
//     String? iosSdk,
//   });
// }
//
// /// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthConfig.copyWith(...)`.
// class _$AuthConfigCWProxyImpl implements _$AuthConfigCWProxy {
//   final AuthConfig _value;
//
//   const _$AuthConfigCWProxyImpl(this._value);
//
//   @override
//
//   /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
//   ///
//   /// Usage
//   /// ```dart
//   /// AuthConfig(...).copyWith(id: 12, name: "My name")
//   /// ````
//   AuthConfig call({
//     Object? androidSdk = const $CopyWithPlaceholder(),
//     Object? authUIConfig = const $CopyWithPlaceholder(),
//     Object? authUIStyle = const $CopyWithPlaceholder(),
//     Object? iosSdk = const $CopyWithPlaceholder(),
//     Object? enableLog = const $CopyWithPlaceholder(),
//   }) {
//     return AuthConfig(
//       androidSdk:
//           androidSdk == const $CopyWithPlaceholder() || androidSdk == null
//               ? _value.androidSdk
//               // ignore: cast_nullable_to_non_nullable
//               : androidSdk as String,
//       authUIConfig:
//           authUIConfig == const $CopyWithPlaceholder() || authUIConfig == null
//               ? _value.authUIConfig
//               // ignore: cast_nullable_to_non_nullable
//               : authUIConfig as AuthUIConfig,
//       enableLog: enableLog == const $CopyWithPlaceholder() || enableLog == null
//           ? _value.enableLog
//           : enableLog as bool,
//       authUIStyle:
//           authUIStyle == const $CopyWithPlaceholder() || authUIStyle == null
//               ? _value.authUIStyle
//               // ignore: cast_nullable_to_non_nullable
//               : authUIStyle as AuthUIStyle,
//       iosSdk: iosSdk == const $CopyWithPlaceholder() || iosSdk == null
//           ? _value.iosSdk
//           // ignore: cast_nullable_to_non_nullable
//           : iosSdk as String,
//     );
//   }
// }
//
// extension $AuthConfigCopyWith on AuthConfig {
//   /// Returns a callable class that can be used as follows: `instanceOfAuthConfig.copyWith(...)`.
//   // ignore: library_private_types_in_public_api
//   _$AuthConfigCWProxy get copyWith => _$AuthConfigCWProxyImpl(this);
// }
