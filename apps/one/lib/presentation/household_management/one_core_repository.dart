import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/hausehold/finance/lib/household_finances.dart';
import 'package:ednet_one/generated/hausehold/hausehold/lib/household_core.dart';
import 'package:ednet_one/generated/hausehold/member/lib/household_member.dart';
import 'package:ednet_one/generated/hausehold/project/lib/household_project.dart';
import 'package:ednet_one/generated/user/library/lib/user_library.dart';

class OneCoreRepository {
  final HouseholdCoreRepo householdCoreRepo;
  final HouseholdFinancesRepo householdFinancesRepo;
  final HouseholdMemberRepo householdMemberRepo;
  final HouseholdProjectRepo householdProjectRepo;
  final UserLibraryRepo userLibraryRepo;

  OneCoreRepository()
      : householdCoreRepo = HouseholdCoreRepo(),
        householdFinancesRepo = HouseholdFinancesRepo(),
        householdMemberRepo = HouseholdMemberRepo(),
        householdProjectRepo = HouseholdProjectRepo(),
        userLibraryRepo = UserLibraryRepo();

  Domains get domains {
    return Domains()
      ..addFrom(householdCoreRepo.domains)
      ..addFrom(householdFinancesRepo.domains)
      ..addFrom(householdMemberRepo.domains)
      ..addFrom(householdProjectRepo.domains)
      ..addFrom(userLibraryRepo.domains);
  }
}
