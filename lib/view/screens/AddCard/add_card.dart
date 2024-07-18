// ignore_for_file: unnecessary_this

import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/payment_provider.dart';
import 'package:provider/provider.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});
  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(builder: (context, paymentProvider, child) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            CreditCardForm(
              onCreditCardModelChange: onCreditCardModelChange,
              onChange: (String cardnumber, String expiryDate, String cardHolderName, String cvvCode) {
                debugPrint(cardnumber + expiryDate + cardHolderName + cvvCode);
              },
              cardNumber: '',
            ),
          ],
        ),
      );
    });
  }

  var isLoading = false;

  // .... Validation for Month and Year TextInput ....
  String validateMonthAndYear(String value) {
    {
      List<String> monthAndYear = value.split("/");
      if (value.isNotEmpty) {
        if (GetUtils.isNum(monthAndYear[0])) {
          return "Month must be in digit";
        }
        int monthValue = int.parse(monthAndYear[0]);
        if (monthValue > 12) {
          return "Invalid Month";
        }
        if (monthAndYear.length > 1) {
          String value = monthAndYear[1];
          if (value.isNotEmpty) {
            int yearValue = int.parse(monthAndYear[1]);
            Future.delayed(
              Duration.zero,
              () => setState(
                () {
                  month = monthValue.toString();
                  year = yearValue.toString();
                },
              ),
            );

            var now = DateTime.now();
            debugPrint('yearValue $yearValue - now.year ${now.year}');

            if (yearValue < now.year) {
              debugPrint('yearValue $yearValue - now.year ${now.year}');
              return "Invalid Year";
            }
          }
        }
      }
    }
    return "";
  }

  // .... Validation for Numeric value ....
  String validateNumericValue(String value) {
    if (GetUtils.isNum(value)) {
      return "Card number must be in digit";
    }
    return "";
  }

  String month = "";
  String year = "";
  String tokenId = "";
  String cardBrand = "";
  String lastFour = "";

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    debugPrint('onCreditCardModelChange: ${creditCardModel.expiryDate}');
    setState(() {
      Provider.of<OrderProvider>(context, listen: false).cardNumber = creditCardModel.cardNumber;
      Provider.of<OrderProvider>(context, listen: false).expiryDate = creditCardModel.expiryDate;
      Provider.of<OrderProvider>(context, listen: false).cardHolderName = creditCardModel.cardHolderName;
      Provider.of<OrderProvider>(context, listen: false).cvvCode = creditCardModel.cvvCode;
      Provider.of<OrderProvider>(context, listen: false).isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

Map<CardType, Set<List<String>>> cardNumPatterns = <CardType, Set<List<String>>>{
  CardType.visa: <List<String>>{
    <String>['4'],
  },
  CardType.americanExpress: <List<String>>{
    <String>['34'],
    <String>['37'],
  },
  CardType.discover: <List<String>>{
    <String>['6011'],
    <String>['622126', '622925'],
    <String>['644', '649'],
    <String>['65']
  },
  CardType.mastercard: <List<String>>{
    <String>['51', '55'],
    <String>['2221', '2229'],
    <String>['223', '229'],
    <String>['23', '26'],
    <String>['270', '271'],
    <String>['2720'],
  },
};

CardType detectCCType(String cardNumber) {
  //Default card type is other
  CardType cardType = CardType.otherBrand;

  if (cardNumber.isEmpty) {
    return cardType;
  }

  cardNumPatterns.forEach(
    (CardType type, Set<List<String>> patterns) {
      for (List<String> patternRange in patterns) {
        // Remove any spaces
        String ccPatternStr = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
        final int rangeLen = patternRange[0].length;
        // Trim the Credit Card number string to match the pattern prefix length
        if (rangeLen < cardNumber.length) {
          ccPatternStr = ccPatternStr.substring(0, rangeLen);
        }

        if (patternRange.length > 1) {
          // Convert the prefix range into numbers then make sure the
          // Credit Card num is in the pattern range.
          // Because Strings don't have '>=' type operators
          final int ccPrefixAsInt = int.parse(ccPatternStr);
          final int startPatternPrefixAsInt = int.parse(patternRange[0]);
          final int endPatternPrefixAsInt = int.parse(patternRange[1]);
          if (ccPrefixAsInt >= startPatternPrefixAsInt && ccPrefixAsInt <= endPatternPrefixAsInt) {
            // Found a match
            cardType = type;
            break;
          }
        } else {
          // Just compare the single pattern prefix with the Credit Card prefix
          if (ccPatternStr == patternRange[0]) {
            // Found a match
            cardType = type;
            break;
          }
        }
      }
    },
  );

  return cardType;
}

// This method returns the icon for the visa card type if found
// else will return the empty container
Widget getCardTypeIcon(String cardNumber, isSmall) {
  Widget icon;
  switch (detectCCType(cardNumber)) {
    case CardType.visa:
      icon = Image.asset(
        'assets/image/visa.png',
        height: isSmall ? 30 : 64,
        width: 64,
      );

      break;

    case CardType.americanExpress:
      icon = Image.asset(
        'assets/image/amex.png',
        height: isSmall ? 30 : 64,
        width: 64,
      );

      break;

    case CardType.mastercard:
      icon = Image.asset(
        'assets/image/mastercard.png',
        height: isSmall ? 30 : 64,
        width: 64,
      );

      break;

    case CardType.discover:
      icon = Image.asset(
        'assets/image/discover.png',
        height: isSmall ? 30 : 64,
        width: 64,
      );

      break;

    default:
      icon = isSmall
          ? Image.asset(
              'assets/image/credit.png',
              height: isSmall ? 30 : 64,
              width: 64,
            )
          : Container();

      break;
  }

  return icon;
}

class MaskedTextController extends TextEditingController {
  Map<String, RegExp>? translator;
  String mask;

  MaskedTextController({super.text, required this.mask, this.translator}) {
    translator = translator ?? MaskedTextController.getDefaultTranslator();

    addListener(() {
      final String previous = _lastUpdatedText;
      if (beforeChange(previous, this.text)) {
        updateText(this.text);
        afterChange(previous, this.text);
      } else {
        updateText(_lastUpdatedText);
      }
    });

    updateText(this.text);
  }

  Function afterChange = (String previous, String next) {};
  Function beforeChange = (String previous, String next) {
    return true;
  };

  String _lastUpdatedText = '';

  void updateText(String text) {
    this.text = _applyMask(mask, text);

    _lastUpdatedText = this.text;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    updateText(text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    final String text = _lastUpdatedText;
    selection = TextSelection.fromPosition(TextPosition(offset: (text).length));
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      moveCursorToEnd();
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return <String, RegExp>{
      'A': RegExp(r'[A-Za-z]'),
      '0': RegExp(r'[0-9]'),
      '': RegExp(r'[A-Za-z0-9]'),
      '*': RegExp(r'.*')
    };
  }

  String _applyMask(String mask, String value) {
    String result = '';

    int maskCharIndex = 0;
    int valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      final String maskChar = mask[maskCharIndex];
      final String valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (translator!.containsKey(maskChar)) {
        if (translator![maskChar]!.hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}

enum CardType {
  otherBrand,
  mastercard,
  visa,
  americanExpress,
  discover,
}

String randomPic =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9qKR74yvV_QpYzSiDA6i5__nhX223h5WumQ&usqp=CAU';

Widget getRandomBackground(double height, double width) {
  return Flex(
    direction: Axis.horizontal,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.asset(
            "assets/image/card.png",
            height: height,
            width: width,
            fit: BoxFit.fill,
          ),
        ),
      )
    ],
  );
}

Container getChipImage() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: Image.asset(
      'assets/image/chip.png',
      height: 52,
      width: 52,
    ),
  );
}

class CreditCardForm extends StatefulWidget {
  final String cardNumber;
  final String? expiryDate;
  final String? cardHolderName;
  final Function(
    String cardnumber,
    String expiryDate,
    String cardHolderName,
    String cvvCode,
  ) onChange;
  final String? cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color? themeColor;
  final Color textColor;
  final Color? cursorColor;

  const CreditCardForm({
    super.key,
    required this.cardNumber,
    required this.onCreditCardModelChange,
    required this.onChange,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
  });

  @override
  State<CreditCardForm> createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  late CreditCardModel creditCardModel;
  late String cardNumber;
  late String expiryDate;
  late String cardHolderName;
  late String cvvCode;
  bool isCvvFocused = false;
  late Color themeColor;
  bool loading = true;
  final MaskedTextController _cardNumberController = MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController = MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController = TextEditingController();
  final TextEditingController _cvvCodeController = MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    widget.onCreditCardModelChange(creditCardModel);
  }

  createCreditCardModel() {
    cardNumber = widget.cardNumber;
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCardModel(cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        widget.onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        widget.onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        widget.onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        widget.onCreditCardModelChange(creditCardModel);
      });
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator.adaptive(),
          )
        : Container(
            width: 400,
            // margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: .5), borderRadius: BorderRadius.circular(6)),
            child: Theme(
              data: ThemeData(
                primaryColor: themeColor.withOpacity(0.8),
                primaryColorDark: themeColor,
              ),
              child: Form(
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: .5),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Container(
                              height: 45,
                              // padding: const EdgeInsets.symmetric(vertical: 8.0),
                              margin: const EdgeInsets.only(
                                top: 14,
                              ),
                              child: TextFormField(
                                controller: _cardNumberController,
                                cursorColor: widget.cursorColor ?? themeColor,
                                style: TextStyle(
                                  color: widget.textColor,
                                ),
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      top: 10,
                                      left: 16,
                                    ),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                    labelText: 'card number',
                                    hintText: 'xxxx xxxx xxxx xxxx',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Grold',
                                    ),
                                    labelStyle: TextStyle(fontFamily: 'Grold', color: Colors.grey)),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Align(
                              child: SizedBox(height: 25, child: getCardTypeIcon(_cardNumberController.text, true)),
                            ),
                          ),
                          // getCardTypeIcon(widget.cardNumber)
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: .5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              height: 50,
                              // padding: const EdgeInsets.symmetric(vertical: 8.0),
                              margin: const EdgeInsets.only(
                                top: 14,
                              ),
                              child: TextFormField(
                                controller: _expiryDateController,
                                cursorColor: widget.cursorColor ?? themeColor,
                                style: TextStyle(
                                  color: widget.textColor,
                                ),
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      top: 10,
                                      left: 16,
                                    ),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                    labelText: 'expiry date',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Grold',
                                    ),
                                    labelStyle: TextStyle(fontFamily: 'Grold', color: Colors.grey),
                                    hintText: 'MM/YY'),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(top: 14),
                              child: TextField(
                                focusNode: cvvFocusNode,
                                controller: _cvvCodeController,
                                cursorColor: widget.cursorColor ?? themeColor,
                                style: TextStyle(
                                  color: widget.textColor,
                                ),
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      top: 10,
                                      left: 16,
                                    ),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                    labelText: 'CVV',
                                    hintText: 'XXX',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Grold',
                                    ),
                                    labelStyle: TextStyle(fontFamily: 'Grold', color: Colors.grey)),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                onChanged: (String text) {
                                  setState(() {
                                    cvvCode = text;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      // padding: const EdgeInsets.symmetric(vertical: 8.0),
                      margin: const EdgeInsets.only(
                        top: 14,
                      ),
                      child: TextFormField(
                        controller: _cardHolderNameController,
                        cursorColor: widget.cursorColor ?? themeColor,
                        style: TextStyle(
                          color: widget.textColor,
                        ),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                              top: 10,
                              left: 16,
                            ),
                            border: const OutlineInputBorder(borderSide: BorderSide.none),
                            labelText: 'card holder'.tr,
                            hintStyle: const TextStyle(
                              fontFamily: 'Grold',
                            ),
                            labelStyle: const TextStyle(fontFamily: 'Grold', color: Colors.grey)),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class CreditCardModel {
  CreditCardModel(this.cardNumber, this.expiryDate, this.cardHolderName, this.cvvCode, this.isCvvFocused);

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
}
