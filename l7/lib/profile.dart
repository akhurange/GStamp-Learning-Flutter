import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(48), bottomLeft: Radius.circular(48))),
      child: Column(
        children: [
          _profilePic(),
          _profileName(),
          const SizedBox(
            height: 16.0,
          ),
          _healthDetails(),
        ],
      ),
    );
  }

  Widget _profilePic() {
    return const Padding(
      padding: EdgeInsets.all(64.0),
      child: CircleAvatar(
        radius: 80,
        backgroundImage: AssetImage('assets/ash.jpg'),
      ),
    );
  }

  Widget _profileName() {
    return RichText(
      text: TextSpan(
          text: 'Aishwarya\n',
          style: Theme.of(context).textTheme.displaySmall,
          children: [
            TextSpan(
              text: 'Edit Health Details',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.greenAccent),
            ),
          ]),
    );
  }

  Widget _healthDetails() {
    return Card(
      elevation: 16,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _healthDetailsColumn('Weight', '58 Kg'),
            _healthDetailsColumn('height', '168 Cm'),
            _healthDetailsColumn('Blood Group', 'O +ve'),
          ],
        ),
      ),
    );
  }

  Widget _healthDetailsColumn(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
