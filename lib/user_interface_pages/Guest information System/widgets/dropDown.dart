import 'package:aggressor_adventures/model/basicInfoModel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../classes/aggressor_colors.dart';
import '../../../classes/colors.dart';
import '../model/genderModel.dart';
import '../model/masterModel.dart';

class AdventureDropDown extends StatelessWidget {
  final List<MasterModel> item;
  final String hintText;
  final MasterModel? selectedItem;
  final Function(MasterModel?)? onChanged;
  const AdventureDropDown({
    Key? key,
    required this.item,
    required this.hintText,
    required this.onChanged,
    this.selectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 52.h,
      child: DropdownSearch<MasterModel>(
        selectedItem: selectedItem,
        dropdownBuilder: _customDropDownSelectedAdventure,
        items: item, //Get.find<RegistrationController>().states,
        onChanged: onChanged,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            iconColor: AggressorColors.aliceBlue,
            isDense: true,
            fillColor: AggressorColors.textFieldBG,
            contentPadding: EdgeInsets.only(left: 26),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 17),
            filled: true,
            enabledBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: AggressorColors.textFieldBG, width: 0.0),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: AggressorColors.textFieldBG, width: 0.0),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
        ),
        popupProps: PopupProps.menu(
          itemBuilder: _customPopupItemBuilderExample2,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              cursorColor: AggressorColors.aliceBlue,
              decoration: InputDecoration(
                prefixStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding: EdgeInsets.only(left: 25),
                counterText: '',
                fillColor: AggressorColors.textFieldBG,
                filled: true,
                hintText: hintText,
                // labelStyle: TextStyle.textHintColor(),
                // hintStyle: TextStyle.textHintColor(fontSize: 14),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AggressorColors.textFieldBG, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AggressorColors.textFieldBG, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AggressorColors.textFieldBG, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              )),
          fit: FlexFit.loose,
          constraints: BoxConstraints.tightFor(
            // width: Get.width,
            height: 250,
          ),
        ),
      ),
    );
  }

  Widget _customPopupItemBuilderExample2(
    BuildContext context,
    MasterModel? item,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        selected: isSelected,
        title: Text(
          item?.title ?? '',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget _customDropDownSelectedAdventure(
    BuildContext context,
    MasterModel? selectedItem,
  ) {
    return Text(
        selectedItem?.id == null ? hintText : selectedItem!.title.toString(),
        style: selectedItem?.id == null
            ? TextStyle(fontSize: 14)
            : TextStyle(fontSize: 14));
  }
}

class AdventureGenderDropDown extends StatelessWidget {
  final List<BasicInfoModel> item;
  final String hintText;
  final BasicInfoModel? selectedItem;
  final Function(BasicInfoModel?)? onChanged;
  const AdventureGenderDropDown({
    Key? key,
    required this.item,
    required this.hintText,
    required this.onChanged,
    this.selectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 52.h,
      child: DropdownSearch<BasicInfoModel>(
        selectedItem: selectedItem,
        dropdownBuilder: _customDropDownSelectedAdventure,
        items: item, //Get.find<RegistrationController>().states,
        onChanged: onChanged,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            iconColor: AggressorColors.aliceBlue,
            isDense: true,
            fillColor: AggressorColors.textFieldBG,
            contentPadding: EdgeInsets.only(left: 26),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 17),
            filled: true,
            enabledBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: AggressorColors.textFieldBG, width: 0.0),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: AggressorColors.textFieldBG, width: 0.0),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
        ),
        popupProps: PopupProps.menu(
          itemBuilder: _customPopupItemBuilderExample2,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              cursorColor: AggressorColors.aliceBlue,
              decoration: InputDecoration(
                prefixStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding: EdgeInsets.only(left: 25),
                counterText: '',
                fillColor: AggressorColors.textFieldBG,
                filled: true,
                hintText: hintText,
                // labelStyle: TextStyle.textHintColor(),
                // hintStyle: TextStyle.textHintColor(fontSize: 14),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AggressorColors.textFieldBG, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AggressorColors.textFieldBG, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AggressorColors.textFieldBG, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              )),
          fit: FlexFit.loose,
          constraints: BoxConstraints.tightFor(
            // width: Get.width,
            height: 250,
          ),
        ),
      ),
    );
  }

  Widget _customPopupItemBuilderExample2(
    BuildContext context,
    BasicInfoModel? item,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        selected: isSelected,
        title: Text(
          item?.gender ?? '',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget _customDropDownSelectedAdventure(
    BuildContext context,
    BasicInfoModel? selectedItem,
  ) {
    return Text(
        selectedItem?.gender == null
            ? hintText
            : selectedItem!.gender.toString(),
        style: selectedItem?.gender == null
            ? TextStyle(fontSize: 14)
            : TextStyle(fontSize: 14));
  }
}
