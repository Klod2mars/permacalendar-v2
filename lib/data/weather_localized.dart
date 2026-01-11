import 'package:flutter/material.dart';

class WeatherLocalized {
  static String getDescription(int code, Locale locale) {
    // Simplified map for MVP. Ideally fetch from AppLocalizations.
    // Codes based on WMO (OpenMeteo)
    switch (code) {
      case 0: return _t(locale, 'Ciel dégagé', 'Clear sky', 'Cielo despejado', 'Céu limpo', 'Klarer Himmel');
      case 1: 
      case 2: 
      case 3: return _t(locale, 'Partiellement nuageux', 'Partly cloudy', 'Parcialmente nublado', 'Parcialmente nublado', 'Teilweise bewölkt');
      case 45: 
      case 48: return _t(locale, 'Brouillard', 'Fog', 'Niebla', 'Nevoeiro', 'Nebel');
      case 51: 
      case 53: 
      case 55: return _t(locale, 'Bruine', 'Drizzle', 'Llovizna', 'Chuvisco', 'Nieselregen');
      case 61: 
      case 63: 
      case 65: return _t(locale, 'Pluie', 'Rain', 'Lluvia', 'Chuva', 'Regen');
      case 71: 
      case 73: 
      case 75: return _t(locale, 'Neige', 'Snow', 'Nieve', 'Neve', 'Schnee');
      case 95: return _t(locale, 'Orage', 'Thunderstorm', 'Tormenta', 'Trovoada', 'Gewitter');
      default: return _t(locale, 'Inconnu', 'Unknown', 'Desconocido', 'Desconhecido', 'Unbekannt');
    }
  }

  static String _t(Locale locale, String fr, String en, String es, String pt, String de) {
    switch (locale.languageCode) {
      case 'fr': return fr;
      case 'en': return en;
      case 'es': return es;
      case 'pt': return pt;
      case 'de': return de;
      default: return en;
    }
  }
}
