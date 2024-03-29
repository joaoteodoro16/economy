import 'package:brasil_fields/brasil_fields.dart';
import 'package:economy_v2/app/core/app_config.dart';
import 'package:economy_v2/app/core/constants.dart';
import 'package:economy_v2/app/core/models/wallet.dart';
import 'package:economy_v2/app/core/utils/ValueUtil.dart';
import 'package:economy_v2/app/core/widgets/button_default.dart';
import 'package:economy_v2/app/core/widgets/text_form_field_default.dart';
import 'package:economy_v2/app/modules/wallet/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:validatorless/validatorless.dart';

class WalletPage extends StatefulWidget {
  
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ModularState<WalletPage, WalletController> {
  final _valueEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String selectedMonth = 'Janeiro';
  String selectedYear = '2024';

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    _valueEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualizar carteira'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 34),
          child: ListView(
            children: [
              TextFormFieldDefault(
                label: 'Valor R\$',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(),
                ],
                icon: Icons.attach_money_outlined,
                backgroundWhite: true,
                controller: _valueEC,
                type: const TextInputType.numberWithOptions(),
                validator: Validatorless.multiple([
                  Validatorless.min(0, 'Informe um valor correto'),
                  Validatorless.required('Campo obrigatório')
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 8, right: 10, left: 10),
                decoration: BoxDecoration(
                    color: AppConfig.primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  elevation: 16,
                  underline: Container(
                    height: 0,
                  ),
                  dropdownColor: AppConfig.primaryColor,
                  value: selectedYear,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 30,
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value!;
                    });
                  },
                  isExpanded: true,
                  items: listYears.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        alignment: Alignment.center,
                        value: value,
                        child: Center(
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 8, right: 10, left: 10),
                decoration: BoxDecoration(
                    color: AppConfig.primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  elevation: 16,
                  underline: Container(
                    height: 0,
                  ),
                  dropdownColor: AppConfig.primaryColor,
                  value: selectedMonth,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 30,
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value!;
                    });
                  },
                  isExpanded: true,
                  items: listMonth.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        alignment: Alignment.center,
                        value: value,
                        child: Center(
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ButtonDefault(
                title: 'Confirmar',
                onPressed: () async {
                  final validate = _formKey.currentState?.validate() ?? false;
                  if (validate) {
                    await controller.save(
                      Wallet(
                        value: ValueUtil.convertStringToDouble(_valueEC.text),
                        month: listMonth.indexOf(selectedMonth) + 1,
                        year: int.parse(selectedYear),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
