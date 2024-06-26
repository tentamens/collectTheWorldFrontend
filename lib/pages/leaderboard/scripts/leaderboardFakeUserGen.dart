import 'dart:math';

List names = [
  "SolarFlareXpert",
  "MysticEchoPro",
  "QuantumWhisperer",
  "VelvetTempest",
  "NeonNavigator",
  "CosmicPulsar",
  "ShadowPhoenixia",
  "LunarVisionary",
  "SilverSurgeon",
  "ElectricEclipser",
  "RadiantEchol",
  "TwilightVortician",
  "AstralNinjary",
  "CrystalSaber",
  "RogueElemental",
  "EtherealWavist",
  "GalacticVoyager",
  "InfernoBlazer",
  "FrostByter",
  "CelestialVoyagist"
];

class LeaderboardFakeUserGen {
  List<dynamic> generateFakeUsers(int amountOfUserToCreate, int pageId) {
    amountOfUserToCreate = amountOfUserToCreate * -1;
    final random = Random();
    List generatedUser = [];
    List copyNames = List.from(names);

    for (var i = 0; i < amountOfUserToCreate; i++) {
      int randomNum = random.nextInt(copyNames.length);
      String username = copyNames[randomNum];
      copyNames.remove(username);
      int xp = generateXP(pageId);
      List user = [username, xp, null, null];
      generatedUser.add(user);
    }

    return generatedUser;
  }

  int generateXP(int multi) {
    final random = Random();
    var xpCount = random.nextInt((75 * (multi * 2))) + 50 * multi;
    return roundTo5(xpCount);
  }

  int roundTo5(int number) {
    return (number / 5).round() * 5;
  }
}
