import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/user_profile/data/model/user_set_contact.dart';
import 'package:newprovider/shared/app_text_field.dart';
import '../../../../core/app_style.dart';
import '../../../../shared/app_button.dart.dart';
import '../state/user_contoller.dart';

class ContactForm extends ConsumerStatefulWidget {
  const ContactForm({super.key, required this.setContact});
   final UserSetContact setContact;

  @override
  ConsumerState<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends ConsumerState<ContactForm> {

  final _key = GlobalKey<FormState>();
  late final TextEditingController _facebookCtrl;
  late final TextEditingController _telegramCtrl;
  late final TextEditingController _phoneNumberCtrl;

  @override
  void initState(){
    super.initState();
     _facebookCtrl = TextEditingController(text: widget.setContact.facebookLink ?? '');
     _telegramCtrl = TextEditingController(text : widget.setContact.telegramLink ?? '');
     _phoneNumberCtrl = TextEditingController(text: widget.setContact.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _facebookCtrl.dispose();
    _telegramCtrl.dispose();
    _phoneNumberCtrl.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodySmall = AppStyle.bodySizeSmall(context);
    final iconSize = AppStyle.iconSize(context);

    Future<String> createContact(UserSetContact request) async{
       request.facebookLink = _facebookCtrl.text;
       request.telegramLink = _telegramCtrl.text;
       request.phoneNumber = _phoneNumberCtrl.text;
      return await ref
          .read(userControllerProvider.notifier)
          .createContact(request);
    }

    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header hint ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.6,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Create your own contact information',
                        style: TextStyle(
                          fontSize: bodySmall,
                          color: theme.colorScheme.onPrimaryContainer,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // ── Current password card ─────────────────────────────
              AppTextField(
                label: 'Facebook Link',
                hint: 'Optional',
                controller: _facebookCtrl,
                iosStyle: true,
                prefixIcon: const Icon(Icons.facebook_rounded),
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              Column(
                children: [
                  AppTextField(
                    label: 'Telegram',
                    hint: 'Optional',
                    controller: _telegramCtrl,
                    iosStyle: true,
                    prefixIcon: const Icon(Icons.telegram_rounded),
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      return null;
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  AppTextField(
                    label: 'Number Phone',
                    hint: 'Phone',
                    controller: _phoneNumberCtrl,
                    iosStyle: true,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    textInputAction: TextInputAction.done,
                    validator: (v) {
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 36),
              AppButton(
                isFullWidth: true,
                isRounded: true,
                label: 'Save',
                prefixIcon: Icon(
                  Icons.check_rounded,
                  size: iconSize,
                  color: theme.colorScheme.onPrimary,
                ),
                onPressed: () async {
                  if (!_key.currentState!.validate()) return;
                  final message = await createContact(widget.setContact);
                  ref.read(userControllerProvider.notifier).refreshUser();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                isFullWidth: true,
                isRounded: true,
                label: 'Cancel',
                style: AppButtonStyle.text,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
