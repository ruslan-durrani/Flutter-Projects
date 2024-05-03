class Education{
  final String organisation;
  final String duration;
  final String length;

  Education({required this.organisation, required this.duration,required this.length,});
}

List<Education> educationList = [
  Education(organisation: "COMSATS University Islamabad", duration: "2020 - Present",length: "4 yr" ),
  Education(organisation: "Roots College International", duration: "2018 - 2020",length: "2 yr"),
  Education(organisation: "Allied Schools", duration: "2016-2018",length: "2 yr" ),
];