import 'package:currencies/pages/overview.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart'; // Для открытия файла
import 'package:share_plus/share_plus.dart'; // Для возможности поделиться файлом
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart'; // Для открытия файла
import 'package:share_plus/share_plus.dart'; // Для возможности поделиться файлом

class SalesData {
  final String
      category; // Для категориальных данных (месяц, день недели и т.д.)
  final double value; // Значение для отображения
  final String? country; // Дополнительное поле для круговой диаграммы

  SalesData(this.category, this.value, [this.country]);
}

// Добавляем новый класс для хранения данных транзакций по валютам
class CurrencyTransactionData {
  final String currency;
  final double sellAmount;
  final double buyAmount;

  CurrencyTransactionData(this.currency, this.sellAmount, this.buyAmount);
}

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  bool _showHours = false;
  String? _selectedDay;

// Добавляем в класс _InformationState
  String _selectedCurrency = 'USD';
  String _selectedOperation = 'sell';

  Set<String> _getAvailableCurrencies() {
    return _transactions.map((t) => t['currency'] as String).toSet();
  }

  DateTimeRange? _selectedDateRange;
  List<Map<String, dynamic>> _filteredTransactions = [];

  Future<void> generatePdf() async {
  // Создаем документ и страницу
  final PdfDocument document = PdfDocument();
  final PdfPage page = document.pages.add();

  // Используем стандартные шрифты без кириллицы
  final PdfStandardFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
  final PdfStandardFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
  final PdfStandardFont boldFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);

  // Отступы
  final double margin = 40;
  double yPosition = margin;

  // Заголовок (только латиница)
  page.graphics.drawString('Transaction Report', 
    titleFont,
    brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    bounds: Rect.fromLTWH(margin, yPosition, page.getClientSize().width - margin * 2, 30)
  );
  yPosition += 40;

  // Дата создания
  page.graphics.drawString('Date: ${DateTime.now().toString().split('.')[0]}', 
    normalFont,
    brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    bounds: Rect.fromLTWH(margin, yPosition, page.getClientSize().width - margin * 2, 20)
  );
  yPosition += 30;

  // Если выбран диапазон дат
  if (_selectedDateRange != null) {
    page.graphics.drawString(
      'Period: ${DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end)}',
      normalFont,
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(margin, yPosition, page.getClientSize().width - margin * 2, 20)
    );
    yPosition += 30;
  }

  // Общая сумма транзакций
  page.graphics.drawString(
    'Profit: ${calculateTransactionSum(_filteredTransactions)} KGS',
    boldFont,
    brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    bounds: Rect.fromLTWH(margin, yPosition, page.getClientSize().width - margin * 2, 20)
  );
  yPosition += 40;

  // Создаем таблицу
  final PdfGrid grid = PdfGrid();
  grid.style = PdfGridStyle(
    font: normalFont,
    cellPadding: PdfPaddings(left: 5, right: 5, top: 5, bottom: 5)
  );

  // Добавляем колонки
  grid.columns.add(count: 7);
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  headerRow.cells[0].value = 'ID';
  headerRow.cells[1].value = 'Operation'; // Только латиница
  headerRow.cells[2].value = 'Currency';
  headerRow.cells[3].value = 'Quantity';
  headerRow.cells[4].value = 'Rate';
  headerRow.cells[5].value = 'Description';
  headerRow.cells[6].value = 'Date';

  // Стилизуем заголовок
  headerRow.style.font = boldFont;
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(66, 114, 196));
  headerRow.style.textBrush = PdfSolidBrush(PdfColor(255, 255, 255));

  // Добавляем данные (не более 30 строк)
  int maxRows = _filteredTransactions.length > 30 ? 30 : _filteredTransactions.length;
  
  for (int i = 0; i < maxRows; i++) {
    var transaction = _filteredTransactions[i];
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = '${transaction['id'] ?? i+1}';
    // Заменяем кириллицу на латиницу в операциях
    row.cells[1].value = transaction['operation'] == 'sell' ? 'Sell' : 'Buy';
    row.cells[2].value = '${transaction['currency']}';
    row.cells[3].value = '${transaction['quantity']}';
    row.cells[4].value = '${transaction['rate']}';
    // Удаляем русские символы из описания при необходимости
    row.cells[5].value = transaction['description']?.replaceAll(RegExp(r'[^\x00-\x7F]'), '') ?? '';
    row.cells[6].value = '${transaction['created_at']}';
  }

  // Рисуем таблицу
  grid.draw(
    page: page,
    bounds: Rect.fromLTWH(margin, yPosition, page.getClientSize().width - margin * 2, 0)
  );

  // Сохраняем PDF
   // или getExternalStoragePublicDirectory(Directory.downloads)
  final directory = await getExternalStorageDirectory(); //getExternalStoragePublicDirectory(Directory.downloads)
  final path = '${directory?.path}/transactions_${DateTime.now().millisecondsSinceEpoch}.pdf';
  final File file = File(path);
  await file.writeAsBytes(await document.save());
  document.dispose();

  // Показываем простой диалог без локализации
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('PDF Created'),
      content: Text('What would you like to do with the file?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            OpenFile.open(file.path);
          },
          child: Text('Open'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Share.shareXFiles([XFile(file.path)], text: 'Transaction Report');
          },
          child: Text('Share'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    ),
  );
}

// Диалог для выбора действия с PDF
  void _showPdfActionDialog(BuildContext context, File file, String fileName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('PDF создан'),
        content: Text('Что вы хотите сделать с файлом "$fileName"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              OpenFile.open(file.path);
            },
            child: Text('Открыть'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Share.shareXFiles([XFile(file.path)],
                  text: 'Отчет по транзакциям');
            },
            child: Text('Поделиться'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _filteredTransactions =
        _transactions; // Изначально показываем все транзакции
  }

// Метод для фильтрации транзакций по дате
  void _filterTransactionsByDate(DateTimeRange? dateRange) {
    setState(() {
      _selectedDateRange = dateRange;

      if (dateRange == null) {
        _filteredTransactions = _transactions;
      } else {
        _filteredTransactions = _transactions.where((transaction) {
          try {
            DateTime date =
                DateFormat('yyyy-MM-dd HH:mm').parse(transaction['created_at']);
            return date.isAfter(dateRange.start.subtract(Duration(days: 1))) &&
                date.isBefore(dateRange.end.add(Duration(days: 1)));
          } catch (e) {
            return false;
          }
        }).toList();
      }
    });
  }

// Метод для открытия диалога выбора даты
  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialEntryMode:
          DatePickerEntryMode.calendarOnly, // ← Убирает иконку карандаша
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      currentDate: DateTime.now(),
      saveText: 'Применить',
      helpText: '', // Убираем карандаш (поле ввода даты)
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _filterTransactionsByDate(picked);
    }
  }

// Метод для подготовки данных по динамике курса
  List<SalesData> _prepareCurrencyTrendData() {
    // Фильтруем транзакции по выбранной валюте и типу операции
    var filteredTransactions = _filteredTransactions
        .where((t) =>
            t['currency'] == _selectedCurrency &&
            t['operation'] == _selectedOperation)
        .toList();

    // Группируем по дате и вычисляем средний курс
    Map<String, List<double>> dateRates = {};

    for (var transaction in filteredTransactions) {
      String date = transaction['created_at']
          .toString()
          .split(' ')[0]; // Берем только дату
      double rate = transaction['rate'];

      if (!dateRates.containsKey(date)) {
        dateRates[date] = [];
      }
      dateRates[date]!.add(rate);
    }

    // Сортируем по дате и вычисляем средний курс для каждой даты
    var sortedDates = dateRates.keys.toList()..sort();

    return sortedDates.map((date) {
      double avgRate =
          dateRates[date]!.reduce((a, b) => a + b) / dateRates[date]!.length;
      return SalesData(date, avgRate);
    }).toList();
  }

// Метод для подготовки данных по дням недели
  List<SalesData> _prepareWeeklyData() {
    // Группируем транзакции по дням недели
    Map<String, int> dayCounts = {
      'Пн': 0,
      'Вт': 0,
      'Ср': 0,
      'Чт': 0,
      'Пт': 0,
      'Сб': 0,
      'Вс': 0
    };

    for (var transaction in _filteredTransactions) {
      DateTime date =
          DateFormat('yyyy-MM-dd HH:mm').parse(transaction['created_at']);
      String day = _getDayOfWeek(date.weekday);
      dayCounts.update(day, (value) => value + 1);
    }

    return dayCounts.entries
        .map((e) => SalesData(e.key, e.value.toDouble()))
        .toList();
  }

// Метод для подготовки данных по часам выбранного дня
  List<SalesData> _prepareHourlyData(String day) {
    Map<int, int> hourCounts = {};
    for (int i = 0; i < 24; i++) {
      hourCounts[i] = 0;
    }

    for (var transaction in _filteredTransactions) {
      DateTime date =
          DateFormat('yyyy-MM-dd HH:mm').parse(transaction['created_at']);
      if (_getDayOfWeek(date.weekday) == day) {
        hourCounts.update(date.hour, (value) => value + 1);
      }
    }

    return hourCounts.entries
        .map((e) => SalesData('${e.key}:00', e.value.toDouble()))
        .toList();
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Пн';
      case 2:
        return 'Вт';
      case 3:
        return 'Ср';
      case 4:
        return 'Чт';
      case 5:
        return 'Пт';
      case 6:
        return 'Сб';
      case 7:
        return 'Вс';
      default:
        return '';
    }
  }

  // В классе _InformationState добавляем метод для подготовки данных
  List<CurrencyTransactionData> _prepareTransactionData() {
    Map<String, double> sellTotals = {};
    Map<String, double> buyTotals = {};

    for (var transaction in _filteredTransactions) {
      String currency = transaction['currency'];
      double quantity = transaction['quantity'];

      if (transaction['operation'] == 'sell') {
        sellTotals.update(currency, (value) => value + quantity,
            ifAbsent: () => quantity);
      } else if (transaction['operation'] == 'buy') {
        buyTotals.update(currency, (value) => value + quantity,
            ifAbsent: () => quantity);
      }
    }

    // Получаем список всех валют
    Set<String> allCurrencies = Set.from(sellTotals.keys)
      ..addAll(buyTotals.keys);

    // Сортируем валюты по убыванию общего объема
    var sortedCurrencies = allCurrencies.toList()
      ..sort((a, b) {
        double totalA = (sellTotals[a] ?? 0) + (buyTotals[a] ?? 0);
        double totalB = (sellTotals[b] ?? 0) + (buyTotals[b] ?? 0);
        return totalB.compareTo(totalA);
      });

    // Преобразуем в список CurrencyTransactionData
    return sortedCurrencies
        .map((currency) => CurrencyTransactionData(
              currency,
              sellTotals[currency] ?? 0,
              buyTotals[currency] ?? 0,
            ))
        .toList();
  }

  ////////////////////////////////////////////////////////////////////// список существующих транзакций
  List<Map<String, dynamic>> _transactions = [
    {
      'id': 1,
      'operation': 'sell',
      'currency': 'CNY',
      'quantity': 758.3,
      'rate': 531.03,
      'description': 'Transaction 1',
      'created_at': '2025-03-18 11:55'
    },
    {
      'id': 2,
      'operation': 'sell',
      'currency': 'EUR',
      'quantity': 554.48,
      'rate': 438.82,
      'description': 'Transaction 2',
      'created_at': '2025-03-13 22:30'
    },
    {
      'id': 3,
      'operation': 'buy',
      'currency': 'EUR',
      'quantity': 361.06,
      'rate': 326.28,
      'description': 'Transaction 3',
      'created_at': '2025-03-07 15:08'
    },
    {
      'id': 4,
      'operation': 'buy',
      'currency': 'USD',
      'quantity': 842.35,
      'rate': 226.09,
      'description': 'Transaction 4',
      'created_at': '2025-03-14 06:27'
    },
    {
      'id': 5,
      'operation': 'buy',
      'currency': 'EUR',
      'quantity': 851.42,
      'rate': 539.99,
      'description': 'Transaction 5',
      'created_at': '2025-03-31 08:04'
    },
    {
      'id': 100,
      'operation': 'sell',
      'currency': 'USD',
      'quantity': 979.07,
      'rate': 80.38,
      'description': 'Transaction 100',
      'created_at': '2025-03-18 07:35'
    }
  ];

  // 🔹 Метод для заголовков секций
  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  double calculateTransactionSum(List<Map<String, dynamic>> transactions) {
    double totalSum = 0.0;

    for (var transaction in transactions) {
      double amount = transaction['quantity'] * transaction['rate'];

      if (transaction['operation'] == 'sell') {
        totalSum += amount; // Для продажи суммируем
      } else if (transaction['operation'] == 'buy') {
        totalSum -= amount; // Для покупки вычитаем
      }
    }

    return double.parse(
        totalSum.toStringAsFixed(2)); // Округляем до 2 знаков после запятой
  }

  // Метод для расчета распределения валют
  List<SalesData> _calculateCurrencyDistribution() {
    Map<String, double> currencyTotals = {};

    for (var transaction in _filteredTransactions) {
      double amount = transaction['quantity'] * transaction['rate'];
      String currency = transaction['currency'];

      if (transaction['operation'] == 'sell') {
        currencyTotals.update(currency, (value) => value + amount,
            ifAbsent: () => amount);
      } else if (transaction['operation'] == 'buy') {
        currencyTotals.update(currency, (value) => value - amount,
            ifAbsent: () => -amount);
      }
    }

    // Преобразуем в список SalesData
    return currencyTotals.entries
        .map((entry) => SalesData(entry.key, entry.value.abs(), entry.key))
        .toList();
  }

  // Метод сброса фильтра
  void _resetFilter() {
    setState(() {
      _selectedDateRange = null;
      _filteredTransactions = _transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyData = _calculateCurrencyDistribution();

    final data = _prepareTransactionData();

    /////////////////////////////////////////////////////////////////////////////////////////////////// Scaffold - основная структура экрана
    return Scaffold(
      backgroundColor: Colors.black87,
      /////////////////////////////////////////////////////////////////////////////////////////// AppBar - верхняя панель
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Statistics', style: TextStyle(color: Colors.white)),
        centerTitle: true,

        // Добавляем кнопку сброса фильтра в leading
        leading: IconButton(
          icon: Icon(Icons.refresh, color: Colors.white), // Иконка сброса
          onPressed: _resetFilter, // Вызывает метод сброса
        ),

        //////////////////////////////////////////////////////////////////////////////// actions - список кнопок в AppBar
        actions: [
          // Иконка для открытия нового окна "Обзор"
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Открываем новое окно "Обзор" через push
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Overview()), // Здесь создаем новый маршрут
              );
            },
          ),

          // Иконка для экспорта в PDF
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: Colors.white),
            onPressed: generatePdf,
          ),

          // Иконка для экспорта в Excel
          IconButton(
            icon: Icon(Icons.table_chart, color: Colors.white),
            onPressed: () {
              // Логика для экспорта в Excel будет добавлена позже
            },
          ),

          // Иконка для фильтрации по датам
          IconButton(
            icon: Icon(Icons.calendar_today,
                color: Colors.white), // Иконка календаря
            onPressed: _showDateRangePicker,
          ),
        ],
      ),

      ////////////////////////////////////////// список динамических заголовков
      body: CustomScrollView(
        slivers: [
          // 🔹 Динамический заголовок
          SliverAppBar(
            expandedHeight: 100.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Прибыль в Сомах: ${calculateTransactionSum(_filteredTransactions)}"),
                  if (_selectedDateRange != null)
                    Text(
                      "Период: ${DateFormat('dd.MM.yyyy').format(_selectedDateRange!.start)} - ${DateFormat('dd.MM.yyyy').format(_selectedDateRange!.end)}",
                      style: TextStyle(fontSize: 14),
                    ),
                ],
              ),
              background: Container(
                color: Colors.blueGrey,
              ),
            ),
          ),

          //  график "По количеству транзакций", где синие - покупки, красные - продажи
          _buildSectionTitle("По количеству транзакций"),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                "График показывает количество операций покупки (синие столбцы) и продажи (красные столбцы) по разным валютам. Чем выше столбец - тем больше операций было совершено с данной валютой.",
                style: TextStyle(color: Colors.white70, fontSize: 20),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 500,
              padding: EdgeInsets.all(16),
              child: SfCartesianChart(
                title: ChartTitle(text: 'Объем операций по валютам'),
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Валюта'),
                  labelPlacement: LabelPlacement.betweenTicks,
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Количество'),
                ),
                series: <CartesianSeries>[
                  ColumnSeries<CurrencyTransactionData, String>(
                    name: 'Продажи',
                    dataSource: data,
                    xValueMapper: (data, _) => data.currency,
                    yValueMapper: (data, _) => data.sellAmount,
                    color: Colors.red,
                    width: 0.5, // Ширина столбца
                    spacing: 0.2, // Отступ между группами
                  ),
                  ColumnSeries<CurrencyTransactionData, String>(
                    name: 'Покупки',
                    dataSource: data,
                    xValueMapper: (data, _) => data.currency,
                    yValueMapper: (data, _) => data.buyAmount,
                    color: Colors.blue,
                    width: 0.5, // Ширина столбца
                    spacing: 0.2, // Отступ между группами
                  ),
                ],
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  textStyle: TextStyle(color: Colors.white),
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  header: '',
                  format: 'point.x : point.y',
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          // динамический столбчатый график по дням недели (с детализацией по часам каждый)
          _buildSectionTitle("По дням недели"),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                "На графике отображается активность операций по дням недели. Вы можете выбрать конкретный день, чтобы увидеть распределение транзакций по часам.",
                style: TextStyle(color: Colors.white70, fontSize: 20),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Кнопки дней недели
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'].map((day) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _selectedDay == day ? Colors.blue : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_selectedDay == day && _showHours) {
                                // Если уже показываем часы этого дня - возвращаем дни недели
                                _showHours = false;
                                _selectedDay = null;
                              } else {
                                // Иначе показываем часы выбранного дня
                                _showHours = true;
                                _selectedDay = day;
                              }
                            });
                          },
                          child: Text(day),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // сам столбчатый график, по дням или неделям
                Container(
                  height: 300,
                  padding: EdgeInsets.all(16),
                  child: SfCartesianChart(
                    title: ChartTitle(
                        text: _showHours
                            ? 'Транзакции по часам ($_selectedDay)'
                            : 'Транзакции по дням недели'),
                    primaryXAxis: CategoryAxis(
                      title:
                          AxisTitle(text: _showHours ? 'Часы' : 'Дни недели'),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Количество транзакций'),
                    ),
                    series: <ColumnSeries<SalesData, String>>[
                      ColumnSeries<SalesData, String>(
                        dataSource: _showHours
                            ? _prepareHourlyData(_selectedDay ?? 'Пн')
                            : _prepareWeeklyData(),
                        xValueMapper: (SalesData sales, _) => sales.category,
                        yValueMapper: (SalesData sales, _) => sales.value,
                        color: Colors.blue,
                        width: _showHours ? 0.2 : 0.4,
                      ),
                    ],
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      format: 'point.x : point.y',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // секция с линейным графиком
          _buildSectionTitle("По динамике роста валюты"),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                "Линейный график демонстрирует изменение курса выбранной валюты за период. Вы можете сравнить динамику цен на покупку и продажу.",
                style: TextStyle(color: Colors.white70, fontSize: 20),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              height: 350,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Выбор валюты и типа операции
                  Row(
                    children: [
                      // Выбор валюты
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _getAvailableCurrencies().map((currency) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: ChoiceChip(
                                  label: Text(currency),
                                  selected: _selectedCurrency == currency,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCurrency = currency;
                                    });
                                  },
                                  selectedColor: Colors.blue,
                                  labelStyle: TextStyle(
                                    color: _selectedCurrency == currency
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      // Выбор операции
                      DropdownButton<String>(
                        value: _selectedOperation,
                        items: [
                          DropdownMenuItem(
                            value: 'sell',
                            child: Text('Продажа',
                                style: TextStyle(color: Colors.red)),
                          ),
                          DropdownMenuItem(
                            value: 'buy',
                            child: Text('Покупка',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedOperation = value!;
                          });
                        },
                        dropdownColor: Colors.grey[900],
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),

                  // График
                  Expanded(
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text:
                            'Динамика курса $_selectedCurrency ($_selectedOperation)',
                        textStyle: TextStyle(color: Colors.white),
                      ),
                      primaryXAxis: CategoryAxis(
                        title: AxisTitle(text: 'Дата'),
                        labelRotation: -45,
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Курс'),
                      ),
                      series: <LineSeries<SalesData, String>>[
                        LineSeries<SalesData, String>(
                          dataSource: _prepareCurrencyTrendData(),
                          xValueMapper: (SalesData sales, _) => sales.category,
                          yValueMapper: (SalesData sales, _) => sales.value,
                          color: _selectedOperation == 'sell'
                              ? Colors.red
                              : Colors.blue,
                          markerSettings: MarkerSettings(isVisible: true),
                          animationDuration: 1000,
                        ),
                      ],
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        format: 'Дата: point.x\nКурс: point.y',
                        textStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // круговой график по объему валют
          _buildSectionTitle("По объёму валюты"),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                "Круговая диаграмма показывает распределение операций по валютам. Размер сегмента соответствует доле операций с каждой валютой.",
                style: TextStyle(color: Colors.white70, fontSize: 20),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              height: 300,
              padding: EdgeInsets.all(16),
              child: SfCircularChart(
                title: ChartTitle(text: 'Распределение по валютам'),
                legend:
                    Legend(isVisible: true, position: LegendPosition.bottom),
                series: <PieSeries<SalesData, String>>[
                  PieSeries<SalesData, String>(
                    dataSource: currencyData,
                    xValueMapper: (SalesData data, _) => data.country ?? '',
                    yValueMapper: (SalesData data, _) => data.value,
                    dataLabelMapper: (SalesData data, _) =>
                        '${data.country}: ${data.value.toStringAsFixed(2)}',
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.inside,
                      textStyle: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    radius: '70%',
                    explode: true,
                    explodeIndex: 0,
                  ),
                ],
              ),
            ),
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
            2, // Текущий индекс - "История", так как мы на экране транзакций
        onTap: (index) {
          // Обработка нажатий на элементы навигации
          switch (index) {
            case 0:
              // Переход на экран продажи/покупки
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/event');
              break;
            case 2:
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
}
