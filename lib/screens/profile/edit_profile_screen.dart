import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Map<String, String> userInfo = {
    "Full Name": "Arslene Djellouli",
    "Date of Birth": "30-06-2005",
    "Email": "arslenedjellouli@gmail.com",
    "Phone Number": "+213 559 0809 89",
    "Username": "@arslence",
  };

  void _editField(String label) {
    TextEditingController controller =
        TextEditingController(text: userInfo[label]);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // fixed
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text("Edit $label", style: AppTextStyles.heading4),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: controller,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100, 
                  hintText: "Enter new $label",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), 
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      userInfo[label] = controller.text;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), 
                    ),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                  child: const Text("Save", style: AppTextStyles.button), 
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(value, style: AppTextStyles.body)),
            GestureDetector(
              onTap: () => _editField(label),
              child: Text(
                "Change",
                style: AppTextStyles.link.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        const Divider(color: AppColors.divider, thickness: 1),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: AppColors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Modifier Profile", style: AppTextStyles.heading4),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: AppSizes.avatarXxl,
                    height: AppSizes.avatarXxl,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 4),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuB7essqcwpQDWaa2S6u3cMjM6b_AxUXrPcy0xS2AWcqax8wV9l2CvOIgQOaG0BH8ufn-vQgNGIHK9vj3WhKnhUK1so16NdMAEyCRcNvQuP_TS9xNsRjw7_YkCObTqMfxAFYysxBKLTXSR4gCuzMZgAbkqUXJpe65ziUHaab_Zdc6uR0Zte7ol9dJcd3GuDBQauVmBsFpM6HKVgt8b_Gz72LW1m7YVsyZmpLnzBe92LsB7ry0kvUgcbnhnLxs0fi7gRFlVs0-1khdM8f',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: AppSizes.iconSm,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            for (var entry in userInfo.entries)
              _buildInfoItem(entry.key, entry.value),
          ],
        ),
      ),
         bottomNavigationBar: BottomNavBar(
         currentIndex: 1, 
         onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/profile');
          }
         },
        ),
    );
  }
}
