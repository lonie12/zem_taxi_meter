// ignore_for_file: non_constant_identifier_names

import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:kokom/helper/helper.dart';


var outline = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey.shade200, width: 0.1),
  borderRadius: BorderRadius.circular(6),
);

var outline2 = OutlineInputBorder(
  borderSide: const BorderSide(color: Colors.grey, width: 0.7),
  borderRadius: BorderRadius.circular(6),
);

Widget Searchbar({IconData? icon}) {
  return Builder(
    builder: (context) {
      return TextField(
        controller: TextEditingController(),
        maxLines: 1,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          fillColor: Helper.greyTextColor,
          hoverColor: Helper.greyTextColor,
          hintText: "Taper pour rechercher",
          prefixIcon: const Icon(CarbonIcons.search, color: Colors.grey),
          border: outline,
          focusedBorder: outline,
          enabledBorder: outline,
        ),
        style: Theme.of(context).textTheme.bodyLarge,
      );
    },
  );
}

Widget Input(
  String hintText,
  String title,
  TextEditingController controller, {
  TextInputType? type,
  errors,
  maxlines = 1,
  Color? color,
  IconData? prefixicon,
  IconData? suffixicon,
  bool? isPassword,
  bool? visibility,
  Function? pTap,
  bool? prefixIsWidget = false,
  Widget? prefixWidget,
}) {
  return Builder(
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            prefixIsWidget!
                ? prefixWidget ?? Container()
                : Icon(
                    prefixicon,
                    size: 22,
                    color: Helper.greyTextColor,
                  ),
            const SizedBox(width: 2),
            Expanded(
              child: TextField(
                obscureText: visibility ?? false,
                controller: controller,
                maxLines: maxlines,
                keyboardType: type ?? TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  // prefixIcon:
                  suffixIcon: isPassword == true
                      ? InkWell(
                          onTap: () => pTap!(),
                          child: Icon(
                            visibility == false
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        )
                      : Icon(
                          suffixicon,
                          size: 20,
                          color: Helper.greyTextColor,
                        ),
                  contentPadding: const EdgeInsets.all(8),
                  filled: true,
                  fillColor: color ?? Colors.grey.shade300,
                  // hoverColor: Helper.greyTextColor,
                  hintText: hintText,
                  border: outline,
                  enabledBorder: outline,

                  focusedBorder: outline,
                ),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 15, color: Helper.textColor),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Widget Input(
//   String hintText,
//   String title,
//   TextEditingController controller, {
//   TextInputType? type,
//   errors,
//   maxlines = 1,
//   Color? color,
//   IconData? prefixicon,
//   IconData? suffixicon,
//   bool? isPassword,
//   bool? visibility,
//   Function? pTap,
// }) {
//   return Builder(
//     builder: (context) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextField(
//             obscureText: visibility ?? false,
//             controller: controller,
//             maxLines: maxlines,
//             keyboardType: type ?? TextInputType.text,
//             textInputAction: TextInputAction.next,
//             decoration: InputDecoration(
//               prefixIcon: Icon(
//                 prefixicon,
//                 size: 22,
//                 color: Helper.greyTextColor,
//               ),
//               suffixIcon: isPassword == true
//                   ? InkWell(
//                       onTap: () => pTap!(),
//                       child: Icon(
//                         visibility == false
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                       ),
//                     )
//                   : Icon(
//                       suffixicon,
//                       size: 22,
//                       color: Helper.greyTextColor,
//                     ),
//               contentPadding: EdgeInsets.all(15),
//               filled: true,
//               fillColor: color ?? Colors.grey.shade200,
//               // hoverColor: Helper.greyTextColor,
//               hintText: hintText,
//               border: outline,
//               enabledBorder: outline,
//               focusedBorder: outline,
//             ),
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyLarge!
//                 .copyWith(fontSize: 16, color: Helper.textColor),
//           ),
//         ],
//       );
//     },
//   );
// }

Widget Textarea(
  String hintText,
  String title,
  TextEditingController controller, {
  TextInputType? type,
  errors,
  maxlines = 1,
  Color? color,
  IconData? prefixicon,
  IconData? suffixicon,
  bool? isPassword,
  bool? visibility,
  Function? pTap,
  bool? prefixIsWidget = false,
  Widget? prefixWidget,
}) {
  return Builder(
    builder: (context) {
      return TextField(
        controller: controller,
        maxLines: maxlines,
        keyboardType: type ?? TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          border: outline2,
          enabledBorder: outline2,
          focusedBorder: outline2,
          hintText: hintText,
        ),
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontSize: 15, color: Helper.textColor),
      );
    },
  );
}

Widget InputNoBorder(
  BuildContext context,
  String hint,
  TextEditingController controller, {
  TextInputType keyType = TextInputType.text,
  IconData? prefixicon,
  IconData? suffixicon,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyType,
    decoration: InputDecoration(
      fillColor: Helper.greyTextColor,
      hoverColor: Helper.greyTextColor,
      hintText: hint,
      prefixIcon: Icon(prefixicon, size: 22, color: Helper.greyTextColor),
      suffixIcon: Icon(suffixicon, size: 22, color: Helper.greyTextColor),
    ),
    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15),
  );
}

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final void Function(String?)? onChanged;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.hintText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        items: items
            .map((String option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        hint: Text(hintText),
        icon: Icon(
          Icons.expand_more,
          color: Helper.primary,
        ),
        onChanged: onChanged,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

//  CustomDropdown(
//                           items: const ["Pizza", "Kom", "Koliko"],
//                           hintText: "Selectionner une catégorie",
//                           onChanged: (value) {
//                             print(value);
//                           },
//                         ),
