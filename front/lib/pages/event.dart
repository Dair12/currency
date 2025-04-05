import 'package:flutter/material.dart';
import '../main.dart';

class Event extends StatefulWidget {
  ////////////////////////////////////////////////////// конструктор, который передаёт ключ key родительскому классу StatefulWidget
  const Event({super.key});

  @override
  State<Event> createState() => _EventState();
  ////////////////////////////////////////////////////////// _EventState - будет управлять состоянием этого экрана.
}

//////////////////////////////////////////////////////////// позволяет обновлять UI при изменении данных
class _EventState extends State<Event> {
  bool _isPagination =
      false; /////////////////////////////////// Флаг для управления пагинацией
  TextEditingController _searchController =
      TextEditingController(); //// для управления текстом в поле ввода

  ////////////////////////////////////////////////////////////////////// список существующих транзакций
  List<Map<String, dynamic>> _transactions = [
    {
      'id': 1,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 758.3,
      'rate': 531.03,
      'description': 'Transaction 1',
      'created_at': '2025-03-18 11-55'
    },
    {
      'id': 2,
      'operation': 'sell',
      'currency': 'EUR',
      'quantity': 554.48,
      'rate': 438.82,
      'description': 'Transaction 2',
      'created_at': '2025-03-13 22-30'
    },
    {
      'id': 3,
      'operation': 'buy',
      'currency': 'EUR',
      'quantity': 361.06,
      'rate': 326.28,
      'description': 'Transaction 3',
      'created_at': '2025-03-07 15-08'
    },
    {
      'id': 4,
      'operation': 'buy',
      'currency': 'USD',
      'quantity': 842.35,
      'rate': 226.09,
      'description': 'Transaction 4',
      'created_at': '2025-03-14 06-27'
    },
    {
      'id': 5,
      'operation': 'buy',
      'currency': 'EUR',
      'quantity': 851.42,
      'rate': 539.99,
      'description': 'Transaction 5',
      'created_at': '2025-03-31 08-04'
    },
    {
      'id': 6,
      'operation': 'sell',
      'currency': 'EUR',
      'quantity': 552.44,
      'rate': 738.72,
      'description': 'Transaction 6',
      'created_at': '2025-03-12 20-26'
    },
    {
      'id': 7,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 605.74,
      'rate': 399.92,
      'description': 'Transaction 7',
      'created_at': '2025-03-23 23-58'
    },
    {
      'id': 8,
      'operation': 'buy',
      'currency': 'KGS',
      'quantity': 986.05,
      'rate': 340.87,
      'description': 'Transaction 8',
      'created_at': '2025-03-21 12-33'
    },
    {
      'id': 9,
      'operation': 'sell',
      'currency': 'RUB',
      'quantity': 137.2,
      'rate': 952.76,
      'description': 'Transaction 9',
      'created_at': '2025-03-10 03-23'
    },
    {
      'id': 10,
      'operation': 'buy',
      'currency': 'EUR',
      'quantity': 739.32,
      'rate': 354.53,
      'description': 'Transaction 10',
      'created_at': '2025-03-11 16-06'
    },
    {
      'id': 11,
      'operation': 'buy',
      'currency': 'USD',
      'quantity': 822.91,
      'rate': 434.82,
      'description': 'Transaction 11',
      'created_at': '2025-03-27 05-18'
    },
    {
      'id': 12,
      'operation': 'sell',
      'currency': 'KGS',
      'quantity': 398.66,
      'rate': 213.98,
      'description': 'Transaction 12',
      'created_at': '2025-03-30 00-30'
    },
    {
      'id': 13,
      'operation': 'buy',
      'currency': 'RUB',
      'quantity': 567.64,
      'rate': 960.08,
      'description': 'Transaction 13',
      'created_at': '2025-03-19 10-46'
    },
    {
      'id': 14,
      'operation': 'buy',
      'currency': 'USD',
      'quantity': 346.62,
      'rate': 690.46,
      'description': 'Transaction 14',
      'created_at': '2025-03-15 07-02'
    },
    {
      'id': 15,
      'operation': 'buy',
      'currency': 'KGS',
      'quantity': 364.39,
      'rate': 658.41,
      'description': 'Transaction 15',
      'created_at': '2025-03-25 03-00'
    },
    {
      'id': 16,
      'operation': 'sell',
      'currency': 'RUB',
      'quantity': 865.11,
      'rate': 194.99,
      'description': 'Transaction 16',
      'created_at': '2025-03-09 05-17'
    },
    {
      'id': 17,
      'operation': 'buy',
      'currency': 'EUR',
      'quantity': 514.04,
      'rate': 136.23,
      'description': 'Transaction 17',
      'created_at': '2025-03-27 05-34'
    },
    {
      'id': 18,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 356.42,
      'rate': 856.89,
      'description': 'Transaction 18',
      'created_at': '2025-03-01 06-56'
    },
    {
      'id': 19,
      'operation': 'buy',
      'currency': 'CNY',
      'quantity': 252.12,
      'rate': 120.77,
      'description': 'Transaction 19',
      'created_at': '2025-03-17 20-24'
    },
    {
      'id': 20,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 21.87,
      'rate': 530.49,
      'description': 'Transaction 20',
      'created_at': '2025-03-26 22-24'
    },
    {
      'id': 21,
      'operation': 'sell',
      'currency': 'USD',
      'quantity': 903.63,
      'rate': 323.38,
      'description': 'Transaction 21',
      'created_at': '2025-03-14 23-44'
    },
    {
      'id': 22,
      'operation': 'buy',
      'currency': 'KGS',
      'quantity': 888.04,
      'rate': 233.7,
      'description': 'Transaction 22',
      'created_at': '2025-03-24 05-44'
    },
    {
      'id': 23,
      'operation': 'buy',
      'currency': 'CNY',
      'quantity': 164.74,
      'rate': 882.34,
      'description': 'Transaction 23',
      'created_at': '2025-03-26 21-35'
    },
    {
      'id': 24,
      'operation': 'buy',
      'currency': 'CNY',
      'quantity': 395.61,
      'rate': 623.08,
      'description': 'Transaction 24',
      'created_at': '2025-03-02 08-14'
    },
    {
      'id': 25,
      'operation': 'buy',
      'currency': 'KGS',
      'quantity': 682.21,
      'rate': 434.17,
      'description': 'Transaction 25',
      'created_at': '2025-03-22 20-44'
    },
    {
      'id': 26,
      'operation': 'sell',
      'currency': 'KGS',
      'quantity': 903.74,
      'rate': 135.94,
      'description': 'Transaction 26',
      'created_at': '2025-04-01 18-53'
    },
    {
      'id': 27,
      'operation': 'sell',
      'currency': 'KGS',
      'quantity': 40.23,
      'rate': 582.87,
      'description': 'Transaction 27',
      'created_at': '2025-03-28 10-25'
    },
    {
      'id': 28,
      'operation': 'sell',
      'currency': 'RUB',
      'quantity': 684.14,
      'rate': 53.84,
      'description': 'Transaction 28',
      'created_at': '2025-03-11 23-56'
    },
    {
      'id': 29,
      'operation': 'sell',
      'currency': 'EUR',
      'quantity': 932.83,
      'rate': 645.9,
      'description': 'Transaction 29',
      'created_at': '2025-03-23 04-15'
    },
    {
      'id': 30,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 521.71,
      'rate': 158.38,
      'description': 'Transaction 30',
      'created_at': '2025-03-17 06-55'
    },
    {
      'id': 31,
      'operation': 'sell',
      'currency': 'USD',
      'quantity': 451.58,
      'rate': 597.53,
      'description': 'Transaction 31',
      'created_at': '2025-03-27 21-45'
    },
    {
      'id': 32,
      'operation': 'buy',
      'currency': 'KGS',
      'quantity': 371.73,
      'rate': 800.36,
      'description': 'Transaction 32',
      'created_at': '2025-03-20 04-51'
    },
    {
      'id': 33,
      'operation': 'buy',
      'currency': 'CNY',
      'quantity': 144.5,
      'rate': 251.35,
      'description': 'Transaction 33',
      'created_at': '2025-03-19 22-38'
    },
    {
      'id': 34,
      'operation': 'sell',
      'currency': 'KGS',
      'quantity': 577.9,
      'rate': 457.3,
      'description': 'Transaction 34',
      'created_at': '2025-04-02 22-45'
    },
    {
      'id': 35,
      'operation': 'sell',
      'currency': 'EUR',
      'quantity': 193.04,
      'rate': 372.29,
      'description': 'Transaction 35',
      'created_at': '2025-03-20 10-59'
    },
    {
      'id': 36,
      'operation': 'buy',
      'currency': 'CNY',
      'quantity': 691.41,
      'rate': 134.97,
      'description': 'Transaction 36',
      'created_at': '2025-03-17 22-50'
    },
    {
      'id': 37,
      'operation': 'buy',
      'currency': 'RUB',
      'quantity': 369.49,
      'rate': 877.56,
      'description': 'Transaction 37',
      'created_at': '2025-03-28 13-45'
    },
    {
      'id': 38,
      'operation': 'sell',
      'currency': 'RUB',
      'quantity': 791.53,
      'rate': 956.66,
      'description': 'Transaction 38',
      'created_at': '2025-03-18 17-42'
    },
    {
      'id': 39,
      'operation': 'buy',
      'currency': 'KGS',
      'quantity': 48.69,
      'rate': 673.37,
      'description': 'Transaction 39',
      'created_at': '2025-03-09 15-15'
    },
    {
      'id': 40,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 378.84,
      'rate': 121.82,
      'description': 'Transaction 40',
      'created_at': '2025-03-27 02-55'
    },
    {
      'id': 41,
      'operation': 'buy',
      'currency': 'USD',
      'quantity': 655.81,
      'rate': 855.53,
      'description': 'Transaction 41',
      'created_at': '2025-03-19 08-21'
    },
    {
      'id': 42,
      'operation': 'buy',
      'currency': 'RUB',
      'quantity': 500.97,
      'rate': 987.3,
      'description': 'Transaction 42',
      'created_at': '2025-03-31 07-54'
    },
    {
      'id': 43,
      'operation': 'buy',
      'currency': 'CNY',
      'quantity': 27.22,
      'rate': 752.79,
      'description': 'Transaction 43',
      'created_at': '2025-03-15 04-49'
    },
    {
      'id': 44,
      'operation': 'sell',
      'currency': 'RUB',
      'quantity': 576.15,
      'rate': 698.46,
      'description': 'Transaction 44',
      'created_at': '2025-03-27 20-40'
    },
    {
      'id': 45,
      'operation': 'buy',
      'currency': 'KGS',
      'quantity': 106.17,
      'rate': 739.7,
      'description': 'Transaction 45',
      'created_at': '2025-03-30 09-40'
    },
    {
      'id': 46,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 109.82,
      'rate': 444.59,
      'description': 'Transaction 46',
      'created_at': '2025-03-30 01-57'
    },
    {
      'id': 47,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 80.42,
      'rate': 330.64,
      'description': 'Transaction 47',
      'created_at': '2025-03-01 20-38'
    },
    {
      'id': 48,
      'operation': 'buy',
      'currency': 'CNY',
      'quantity': 330.94,
      'rate': 880.38,
      'description': 'Transaction 48',
      'created_at': '2025-03-10 15-10'
    },
    {
      'id': 49,
      'operation': 'buy',
      'currency': 'KGS',
      'quantity': 306.81,
      'rate': 327.56,
      'description': 'Transaction 49',
      'created_at': '2025-03-05 15-40'
    },
    {
      'id': 50,
      'operation': 'sell',
      'currency': 'EUR',
      'quantity': 504.01,
      'rate': 743.07,
      'description': 'Transaction 50',
      'created_at': '2025-03-18 07-13'
    },
    {
      'id': 51,
      'operation': 'sell',
      'currency': 'KGS',
      'quantity': 23.74,
      'rate': 782.45,
      'description': 'Transaction 51',
      'created_at': '2025-03-16 02-02'
    },
    {
      'id': 52,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 153.34,
      'rate': 148.34,
      'description': 'Transaction 52',
      'created_at': '2025-03-30 15-00'
    },
    {
      'id': 53,
      'operation': 'sell',
      'currency': 'KGS',
      'quantity': 636.34,
      'rate': 677.89,
      'description': 'Transaction 53',
      'created_at': '2025-03-09 16-14'
    },
    {
      'id': 54,
      'operation': 'buy',
      'currency': 'EUR',
      'quantity': 653.51,
      'rate': 76.78,
      'description': 'Transaction 54',
      'created_at': '2025-03-16 23-12'
    },
    {
      'id': 55,
      'operation': 'sell',
      'currency': 'KGS',
      'quantity': 673.94,
      'rate': 367.72,
      'description': 'Transaction 55',
      'created_at': '2025-03-21 15-30'
    },
    {
      'id': 56,
      'operation': 'buy',
      'currency': 'RUB',
      'quantity': 161.75,
      'rate': 886.25,
      'description': 'Transaction 56',
      'created_at': '2025-04-03 21-34'
    },
    {
      'id': 57,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 701.54,
      'rate': 244.32,
      'description': 'Transaction 57',
      'created_at': '2025-03-19 06-14'
    },
    {
      'id': 58,
      'operation': 'buy',
      'currency': 'USD',
      'quantity': 423.35,
      'rate': 664.46,
      'description': 'Transaction 58',
      'created_at': '2025-03-17 09-15'
    },
    {
      'id': 59,
      'operation': 'sell',
      'currency': 'EUR',
      'quantity': 103.99,
      'rate': 985.68,
      'description': 'Transaction 59',
      'created_at': '2025-03-16 11-33'
    },
    {
      'id': 60,
      'operation': 'buy',
      'currency': 'RUB',
      'quantity': 179.14,
      'rate': 850.13,
      'description': 'Transaction 60',
      'created_at': '2025-03-02 01-08'
    },
    {
      'id': 61,
      'operation': 'buy',
      'currency': 'CNY',
      'quantity': 13.64,
      'rate': 279.03,
      'description': 'Transaction 61',
      'created_at': '2025-03-16 23-24'
    },
    {
      'id': 62,
      'operation': 'sell',
      'currency': 'RUB',
      'quantity': 946.54,
      'rate': 260.67,
      'description': 'Transaction 62',
      'created_at': '2025-03-05 14-47'
    },
    {
      'id': 63,
      'operation': 'buy',
      'currency': 'EUR',
      'quantity': 309.01,
      'rate': 727.33,
      'description': 'Transaction 63',
      'created_at': '2025-03-22 02-52'
    },
    {
      'id': 64,
      'operation': 'sell',
      'currency': 'USD',
      'quantity': 138.88,
      'rate': 707.1,
      'description': 'Transaction 64',
      'created_at': '2025-03-14 11-36'
    },
    {
      'id': 65,
      'operation': 'buy',
      'currency': 'USD',
      'quantity': 791.69,
      'rate': 897.78,
      'description': 'Transaction 65',
      'created_at': '2025-03-05 12-42'
    },
    {
      'id': 66,
      'operation': 'buy',
      'currency': 'RUB',
      'quantity': 621.5,
      'rate': 452.44,
      'description': 'Transaction 66',
      'created_at': '2025-03-27 08-58'
    },
    {
      'id': 67,
      'operation': 'sell',
      'currency': 'RUB',
      'quantity': 903.46,
      'rate': 671.07,
      'description': 'Transaction 67',
      'created_at': '2025-03-18 22-29'
    },
    {
      'id': 68,
      'operation': 'buy',
      'currency': 'CNY',
      'quantity': 722.59,
      'rate': 543.35,
      'description': 'Transaction 68',
      'created_at': '2025-03-15 00-25'
    },
    {
      'id': 69,
      'operation': 'sell',
      'currency': 'RUB',
      'quantity': 380.71,
      'rate': 679.99,
      'description': 'Transaction 69',
      'created_at': '2025-03-31 12-58'
    },
    {
      'id': 70,
      'operation': 'buy',
      'currency': 'RUB',
      'quantity': 603.57,
      'rate': 713.12,
      'description': 'Transaction 70',
      'created_at': '2025-03-06 02-26'
    },
    {
      'id': 71,
      'operation': 'sell',
      'currency': 'KGS',
      'quantity': 633.85,
      'rate': 582.96,
      'description': 'Transaction 71',
      'created_at': '2025-03-24 12-10'
    },
    {
      'id': 72,
      'operation': 'sell',
      'currency': 'KGS',
      'quantity': 420.87,
      'rate': 56.51,
      'description': 'Transaction 72',
      'created_at': '2025-03-22 23-57'
    },
    {
      'id': 73,
      'operation': 'buy',
      'currency': 'KGS',
      'quantity': 894.64,
      'rate': 198.6,
      'description': 'Transaction 73',
      'created_at': '2025-03-12 19-03'
    },
    {
      'id': 74,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 509.78,
      'rate': 643.61,
      'description': 'Transaction 74',
      'created_at': '2025-03-28 19-28'
    },
    {
      'id': 75,
      'operation': 'sell',
      'currency': 'USD',
      'quantity': 995.08,
      'rate': 546.68,
      'description': 'Transaction 75',
      'created_at': '2025-03-22 16-58'
    },
    {
      'id': 76,
      'operation': 'sell',
      'currency': 'EUR',
      'quantity': 251.94,
      'rate': 770.53,
      'description': 'Transaction 76',
      'created_at': '2025-03-25 06-53'
    },
    {
      'id': 77,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 73.84,
      'rate': 986.7,
      'description': 'Transaction 77',
      'created_at': '2025-03-14 17-33'
    },
    {
      'id': 78,
      'operation': 'sell',
      'currency': 'USD',
      'quantity': 187.22,
      'rate': 352.7,
      'description': 'Transaction 78',
      'created_at': '2025-03-02 17-05'
    },
    {
      'id': 79,
      'operation': 'buy',
      'currency': 'CNY',
      'quantity': 570.63,
      'rate': 816.12,
      'description': 'Transaction 79',
      'created_at': '2025-03-12 11-35'
    },
    {
      'id': 80,
      'operation': 'sell',
      'currency': 'RUB',
      'quantity': 36.55,
      'rate': 203.48,
      'description': 'Transaction 80',
      'created_at': '2025-03-07 17-28'
    },
    {
      'id': 81,
      'operation': 'buy',
      'currency': 'USD',
      'quantity': 444.64,
      'rate': 318.56,
      'description': 'Transaction 81',
      'created_at': '2025-03-06 20-04'
    },
    {
      'id': 82,
      'operation': 'buy',
      'currency': 'CNY',
      'quantity': 440.53,
      'rate': 380.38,
      'description': 'Transaction 82',
      'created_at': '2025-03-14 18-23'
    },
    {
      'id': 83,
      'operation': 'buy',
      'currency': 'RUB',
      'quantity': 792.04,
      'rate': 69.62,
      'description': 'Transaction 83',
      'created_at': '2025-03-07 16-58'
    },
    {
      'id': 84,
      'operation': 'buy',
      'currency': 'CNY',
      'quantity': 599.32,
      'rate': 975.09,
      'description': 'Transaction 84',
      'created_at': '2025-03-21 12-39'
    },
    {
      'id': 85,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 656.92,
      'rate': 291.01,
      'description': 'Transaction 85',
      'created_at': '2025-03-09 15-52'
    },
    {
      'id': 86,
      'operation': 'sell',
      'currency': 'USD',
      'quantity': 934.54,
      'rate': 729.75,
      'description': 'Transaction 86',
      'created_at': '2025-03-31 18-48'
    },
    {
      'id': 87,
      'operation': 'sell',
      'currency': 'EUR',
      'quantity': 906.74,
      'rate': 336.27,
      'description': 'Transaction 87',
      'created_at': '2025-03-17 06-54'
    },
    {
      'id': 88,
      'operation': 'sell',
      'currency': 'KGS',
      'quantity': 896.03,
      'rate': 904.16,
      'description': 'Transaction 88',
      'created_at': '2025-03-31 14-40'
    },
    {
      'id': 89,
      'operation': 'sell',
      'currency': 'USD',
      'quantity': 46.0,
      'rate': 479.61,
      'description': 'Transaction 89',
      'created_at': '2025-03-03 01-31'
    },
    {
      'id': 90,
      'operation': 'sell',
      'currency': 'USD',
      'quantity': 765.81,
      'rate': 118.32,
      'description': 'Transaction 90',
      'created_at': '2025-03-31 22-48'
    },
    {
      'id': 91,
      'operation': 'sell',
      'currency': 'USD',
      'quantity': 379.07,
      'rate': 277.16,
      'description': 'Transaction 91',
      'created_at': '2025-03-02 19-57'
    },
    {
      'id': 92,
      'operation': 'buy',
      'currency': 'USD',
      'quantity': 758.94,
      'rate': 362.27,
      'description': 'Transaction 92',
      'created_at': '2025-03-16 17-01'
    },
    {
      'id': 93,
      'operation': 'sell',
      'currency': 'KGS',
      'quantity': 313.25,
      'rate': 149.08,
      'description': 'Transaction 93',
      'created_at': '2025-03-06 19-08'
    },
    {
      'id': 94,
      'operation': 'sell',
      'currency': 'KGS',
      'quantity': 248.62,
      'rate': 681.33,
      'description': 'Transaction 94',
      'created_at': '2025-03-19 14-06'
    },
    {
      'id': 95,
      'operation': 'buy',
      'currency': 'USD',
      'quantity': 451.36,
      'rate': 476.69,
      'description': 'Transaction 95',
      'created_at': '2025-04-01 05-00'
    },
    {
      'id': 96,
      'operation': 'sell',
      'currency': 'USD',
      'quantity': 868.03,
      'rate': 893.72,
      'description': 'Transaction 96',
      'created_at': '2025-03-23 00-57'
    },
    {
      'id': 97,
      'operation': 'buy',
      'currency': 'RUB',
      'quantity': 632.96,
      'rate': 515.34,
      'description': 'Transaction 97',
      'created_at': '2025-03-21 00-45'
    },
    {
      'id': 98,
      'operation': 'sell',
      'currency': 'RUB',
      'quantity': 975.8,
      'rate': 319.83,
      'description': 'Transaction 98',
      'created_at': '2025-03-17 15-21'
    },
    {
      'id': 99,
      'operation': 'buy',
      'currency': 'RUB',
      'quantity': 928.74,
      'rate': 349.3,
      'description': 'Transaction 99',
      'created_at': '2025-03-04 11-02'
    },
    {
      'id': 100,
      'operation': 'sell',
      'currency': 'USD',
      'quantity': 979.07,
      'rate': 80.38,
      'description': 'Transaction 100',
      'created_at': '2025-03-18 07-35'
    }
  ];

  ///////////////////////////////////////////////////////// список отфильтрованных транзакций
  List<Map<String, dynamic>> _filteredTransactions = [];

///////////////////////////////////////////////////////// initState() - выполняется один раз при создании экрана
  @override
  void initState() {
    super.initState();
    _filteredTransactions = List.from(_transactions);
  }

  /////////////////////////////////////// для предотвращения утечки данных
  @override
  void dispose() {
    _searchController
        .dispose(); ///////////////// Освобождение ресурсов поисковика
    super.dispose();
  }

  void _openSearchModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      isScrollControlled: true, // Добавьте это для лучшего отображения
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          // Используем StatefulBuilder для локального состояния
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true, // Автоматически фокусируемся на поле ввода
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Поиск транзакции...',
                      hintStyle: TextStyle(color: Colors.white60),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    //////////////// onChanged - обновляет список транзакций в реальном времени, с каждым новым символом
                    onChanged: (query) {
                      setModalState(() {
                        // Используем setModalState для обновления UI
                        _filteredTransactions = _transactions
                            .where((transaction) =>
                                transaction['description'] != null &&
                                transaction['description']
                                    .toString()
                                    .toLowerCase()
                                    .contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ////////////////////////////////////////////////////////// Отображение списка транзакций
                  _filteredTransactions.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Ничего не найдено',
                            style: TextStyle(color: Colors.white60),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredTransactions.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  _filteredTransactions[index]['description'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /////////////////////////////////////////////////////////////////////////////////////////////////// Scaffold - основная структура экрана
    return Scaffold(
      backgroundColor: Colors.black87,
      /////////////////////////////////////////////////////////////////////////////////////////// AppBar - верхняя панель
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('История операций',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,

        ////////////////////////////////////////////////////////////////////////////////   поиск событий
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: _openSearchModal
              //............................ Тут можно открыть поиск или что-то с ним делать

              /////////////////////////////////// Думаю вставить модальное окно, где будет отображаться иконки, поле, и выводиться транзакции при вводе текста в реал тайм
              ,
            ),
            // Поле для ввода текста поиска
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Поиск транзакции...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  //....................................... Можно добавить логику поиска
                },
              ),
            ),
          ],
        ),

        //////////////////////////////////////////////////////////////////////////////// actions - список кнопок в AppBar
        actions: [
          ////////////////////////////////// вызов фильтра по дате
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _showPeriodDialog(context),
          ),

          ///////////////////////////////////////// переключение между списком и сеткой
          IconButton(
            icon: Icon(_isPagination ? Icons.view_list : Icons.grid_view,
                color: Colors.white),
            onPressed: () {
              setState(() {
                _isPagination = !_isPagination;
              });
              ////........................................ Здесь можно добавить логику обновления списка элементов
            },
          ),
        ],
      ),

      ///////////////////////////////////////////////////////////////////////////////////////// BottomNavigationBar - нижняя навигационная панель
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Продажа/Покупка',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'История',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Статистика',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
        currentIndex:
            1, // Текущий индекс - "История", так как мы на экране транзакций
        onTap: (index) {
          // Обработка нажатий на элементы навигации
          switch (index) {
            case 0:
              // Переход на экран продажи/покупки
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              // Мы уже на экране истории (Event), ничего не делаем
              break;
            case 2:
              // Переход на экран статистики
              Navigator.pushReplacementNamed(context, '/information');
              break;
            case 3:
              // Переход на экран настроек
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  //////////////////////////////////////////////////////////////// Метод для создания кнопок и функционала
  Widget _buildPeriodOption(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),

      //.................................. Добавить обработку выбора периода
    );
  }

  /////////////////////////////////////////////////////////////// Метод для отображения диалогового окна
  void _showPeriodDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //////////////////////////////////////////////////////////////////// Отдельно первый элемент, центрируем его
              _buildPeriodOption(Icons.date_range, 'Выбор диапазона'),
              const SizedBox(height: 10),

              ///////////////////////////////////////////////////////////////////////////// Остальные 6 кнопок в сетке 2x3
              GridView.count(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), ///////////////////////// Отключаем скролл внутри GridView
                crossAxisCount:
                    2, //////////////////////////////////////////////////// Две кнопки в ряд
                childAspectRatio:
                    3, // Соотношение сторон элементов (ширина/высота)
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: [
                  _buildPeriodOption(Icons.all_inclusive, 'Все время'),
                  _buildPeriodOption(Icons.today, 'Выбрать день'),
                  _buildPeriodOption(Icons.calendar_view_week, 'Неделя'),
                  _buildPeriodOption(Icons.calendar_today, 'Сегодня'),
                  _buildPeriodOption(Icons.calendar_view_month, 'Месяц'),
                  _buildPeriodOption(Icons.event, 'Год'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
