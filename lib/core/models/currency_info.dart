
import 'package:flutter/material.dart';

class CurrencyInfo {
  final String code; // e.g. 'EUR'
  final String symbol; // e.g. '€' or '€'
  final String locale; // e.g. 'fr_FR'
  final int decimalDigits; // e.g. 2 for EUR/USD, 0 for JPY
  final IconData? icon; // Optional icon for UI

  const CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.locale,
    this.decimalDigits = 2,
    this.icon,
  });
}

const defaultCurrencies = {
  'EUR': CurrencyInfo(
    code: 'EUR',
    symbol: '€',
    locale: 'fr_FR',
    decimalDigits: 2,
    icon: Icons.euro,
  ),
  'USD': CurrencyInfo(
    code: 'USD',
    symbol: '\$',
    locale: 'en_US',
    decimalDigits: 2,
    icon: Icons.attach_money,
  ),
  'GBP': CurrencyInfo(
    code: 'GBP',
    symbol: '£',
    locale: 'en_GB',
    decimalDigits: 2,
    icon: Icons.currency_pound,
  ),
  'JPY': CurrencyInfo(
    code: 'JPY',
    symbol: '¥',
    locale: 'ja_JP',
    decimalDigits: 0,
    icon: Icons.currency_yen,
  ),
  'CHF': CurrencyInfo(
    code: 'CHF',
    symbol: 'CHF',
    locale: 'de_CH',
    decimalDigits: 2,
    icon: Icons.currency_franc,
  ),
};
