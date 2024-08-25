import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Question> _questions = [
    const Question(
      name: 'Spinach Pizza',
      id: '1',
    ),
    const Question(
      name: 'Veggie Delight',
      id: '2',
    ),
    const Question(
      name: 'Chicken Parmesan',
      id: '3',
    ),
    const Question(
      name: 'Chicken Parmesan2',
      id: '4',
    ),
  ];

  List<String> columns = [
    'وجه المقارنة',
    'نموذج رازارفورد',
    'نموذج بور',
  ];
  List<List<Answer>> rows = [];

  @override
  void initState() {
    super.initState();
    List<Answer> row1 = [
      Answer('العنصر الذى أجريت عليه التجارب', false),
      Answer('الذهب', false),
      Answer('الهيدروجين', false)
    ];
    List<Answer> row2 = [
      Answer('العنصر الذى أجريت عليه التجارب', false),
      Answer('الذهب', false),
      Answer('الهيدروجين', false)
    ];
    rows.add(row1);
    rows.add(row2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                columnSpacing: 0,
                dataTextStyle: const TextStyle(color: Colors.black),
                headingTextStyle: const TextStyle(color: Colors.white),
                horizontalMargin: 0,
                border: TableBorder.all(
                  width: 1.0,
                  color: Colors.black12,
                ),
                headingRowColor:
                    WidgetStateColor.resolveWith((states) => Colors.green),
                columns: columns.reversed.map((column) => DataColumn(
                            label: Flexible(
                                child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(column),
                                    )
                                )
                            )
                )).toList(),
                rows: rows.asMap().entries.map((row) => DataRow(
                  cells: row.value.asMap().entries
                      .map((item) => DataCell(SizedBox.expand(
                      child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: item.key == 0 ? Colors.green : Colors.white,
                          child: Center(
                              child: item.key  == 0 ? Text(
                                item.value._item ?? '',
                                style: TextStyle(
                                    color: item.key == 0
                                        ? Colors.white
                                        : Colors.black),
                              ) : SizedBox.expand(
                                child: DragTarget<Question>(
                                  builder: (context, candidateItems, rejectedItems) {
                                    return AnswerItem(
                                      answer: rows[row.key][item.key],
                                      hasItem: rows[row.key][item.key].hasItem() == true,
                                    );
                                  },
                                  onAcceptWithDetails: (details) {
                                    _itemDroppedOnAnswers(row.key, item.key, Answer(details.data.name, true));
                                  },
                                ),
                              )
                          )
                      )
                  ))).toList().reversed.toList(),
                )).toList(),
              ),
            ),
          ),
          _buildQuestionsList()
        ],
      ),
    );
  }

  Widget _buildQuestionsList() {
    return Wrap(
      alignment: WrapAlignment.end,
      children: _questions.map((question) => _buildQuestionItem(question: question)).toList(),
    );
  }

  Widget _buildQuestionItem({
    required Question question,
  }) {
    return LongPressDraggable<Question>(
      data: question,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: QuestionListItem(
        name: question.name,
      ),
      child: QuestionListItem(
        name: question.name,
      ),
    );
  }

  void _itemDroppedOnAnswers(int rowIndex, int index, Answer answer) {
    setState(() {
      rows[rowIndex][index] = answer;
      _questions.remove(_questions.firstWhere((question) => question.name == answer._item));
    });
  }
}

class AnswerItem extends StatelessWidget {
  const AnswerItem({
    super.key,
    required this.answer,
    required this.hasItem,
  });

  final Answer answer;
  final bool hasItem;

  @override
  Widget build(BuildContext context) {

    return hasItem ? Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            answer.getItem() ?? '',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ) : DottedBorder(
      color: Colors.black,
      strokeWidth: 1,
      borderType: BorderType.RRect,
      radius: const Radius.circular(8),
      child: const SizedBox(
        height: 30,
      ),
    );
  }
}

class QuestionListItem extends StatelessWidget {
  const QuestionListItem({
    super.key,
    this.name = '',
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            name,
          ),
        ),
      ),
    );
  }
}

@immutable
class Question {
  const Question({
    required this.name,
    required this.id,
  });
  final String name;
  final String id;
}

class Answer {
  Answer(this._item, this._hasItem);
  late String? _item;
  late bool? _hasItem;

  String? getItem() => _item;
  void setItem(String item) {
    _item = item;
  }

  bool? hasItem() => _hasItem;
  void setHasItem(bool hasItem) {
    _hasItem = hasItem;
  }
}
