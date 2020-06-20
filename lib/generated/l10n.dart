// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Active Friends`
  String get activeFriendsTitle {
    return Intl.message(
      'Active Friends',
      name: 'activeFriendsTitle',
      desc: '',
      args: [],
    );
  }

  /// `See All Friends`
  String get seeAllFriendsButton {
    return Intl.message(
      'See All Friends',
      name: 'seeAllFriendsButton',
      desc: '',
      args: [],
    );
  }

  /// `Login Failed`
  String get loginFailed {
    return Intl.message(
      'Login Failed',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Friendship`
  String get friendshipLabel {
    return Intl.message(
      'Friendship',
      name: 'friendshipLabel',
      desc: '',
      args: [],
    );
  }

  /// `Current Status`
  String get currentStatusLabel {
    return Intl.message(
      'Current Status',
      name: 'currentStatusLabel',
      desc: '',
      args: [],
    );
  }

  /// `Send Thought`
  String get sendThoughtButton {
    return Intl.message(
      'Send Thought',
      name: 'sendThoughtButton',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yesButton {
    return Intl.message(
      'Yes',
      name: 'yesButton',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get noButton {
    return Intl.message(
      'No',
      name: 'noButton',
      desc: '',
      args: [],
    );
  }

  /// `DELETE FRIEND`
  String get deleteFriendButton {
    return Intl.message(
      'DELETE FRIEND',
      name: 'deleteFriendButton',
      desc: '',
      args: [],
    );
  }

  /// `Include Image`
  String get includeImageLable {
    return Intl.message(
      'Include Image',
      name: 'includeImageLable',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get friendsLabel {
    return Intl.message(
      'Friends',
      name: 'friendsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get signOutLabel {
    return Intl.message(
      'Sign out',
      name: 'signOutLabel',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signInWithGoogleButton {
    return Intl.message(
      'Sign in with Google',
      name: 'signInWithGoogleButton',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginTitle {
    return Intl.message(
      'Login',
      name: 'loginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Phone Authentication`
  String get phoneAuthenticationTitle {
    return Intl.message(
      'Phone Authentication',
      name: 'phoneAuthenticationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Just now`
  String get justNowLabel {
    return Intl.message(
      'Just now',
      name: 'justNowLabel',
      desc: '',
      args: [],
    );
  }

  /// `minute(s) ago`
  String get minutesAgoSuffix {
    return Intl.message(
      'minute(s) ago',
      name: 'minutesAgoSuffix',
      desc: '',
      args: [],
    );
  }

  /// `hour(s) ago`
  String get hoursAgoSuffix {
    return Intl.message(
      'hour(s) ago',
      name: 'hoursAgoSuffix',
      desc: '',
      args: [],
    );
  }

  /// `day(s) ago`
  String get daysAgoSuffix {
    return Intl.message(
      'day(s) ago',
      name: 'daysAgoSuffix',
      desc: '',
      args: [],
    );
  }

  /// `Miss you`
  String get codeMissYouShort {
    return Intl.message(
      'Miss you',
      name: 'codeMissYouShort',
      desc: '',
      args: [],
    );
  }

  /// `I'm thinking about you.`
  String get codeMissYouLong {
    return Intl.message(
      'I\'m thinking about you.',
      name: 'codeMissYouLong',
      desc: '',
      args: [],
    );
  }

  /// `Wish U were here`
  String get codeWishUWereHereShort {
    return Intl.message(
      'Wish U were here',
      name: 'codeWishUWereHereShort',
      desc: '',
      args: [],
    );
  }

  /// `It would be nice if you were here with me now.`
  String get codeWishUWereHereLong {
    return Intl.message(
      'It would be nice if you were here with me now.',
      name: 'codeWishUWereHereLong',
      desc: '',
      args: [],
    );
  }

  /// `Good old time`
  String get codeGoodOldTimeShort {
    return Intl.message(
      'Good old time',
      name: 'codeGoodOldTimeShort',
      desc: '',
      args: [],
    );
  }

  /// `I'm remembering the great time we had together.`
  String get codeGoodOldTimeLong {
    return Intl.message(
      'I\'m remembering the great time we had together.',
      name: 'codeGoodOldTimeLong',
      desc: '',
      args: [],
    );
  }

  /// `Grateful for you`
  String get codeGratefulForYouShort {
    return Intl.message(
      'Grateful for you',
      name: 'codeGratefulForYouShort',
      desc: '',
      args: [],
    );
  }

  /// `I'm so thankful to have you in my life.`
  String get codeGratefulForYouLong {
    return Intl.message(
      'I\'m so thankful to have you in my life.',
      name: 'codeGratefulForYouLong',
      desc: '',
      args: [],
    );
  }

  /// `Phone Call`
  String get codePhoneCallShort {
    return Intl.message(
      'Phone Call',
      name: 'codePhoneCallShort',
      desc: '',
      args: [],
    );
  }

  /// `Video Call`
  String get codeVideoCallShort {
    return Intl.message(
      'Video Call',
      name: 'codeVideoCallShort',
      desc: '',
      args: [],
    );
  }

  /// `In Person`
  String get codeInPersonShort {
    return Intl.message(
      'In Person',
      name: 'codeInPersonShort',
      desc: '',
      args: [],
    );
  }

  /// `Incoming Messages`
  String get incomingMessagesTitle {
    return Intl.message(
      'Incoming Messages',
      name: 'incomingMessagesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contactLabel {
    return Intl.message(
      'Contact',
      name: 'contactLabel',
      desc: '',
      args: [],
    );
  }

  /// `Thought`
  String get thoughtLabel {
    return Intl.message(
      'Thought',
      name: 'thoughtLabel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'jp', countryCode: 'JP'),
      Locale.fromSubtags(languageCode: 'th', countryCode: 'TH'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}