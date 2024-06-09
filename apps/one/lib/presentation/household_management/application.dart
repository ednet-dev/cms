import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/hausehold/finance/lib/finance_household.dart'
    as finance_household;
import 'package:ednet_one/generated/hausehold/project/lib/project_household.dart';
import 'package:ednet_one/generated/user/library/lib/library_user.dart';

import '../../generated/hausehold/hausehold/lib/household_core.dart';

class Application {
  final HouseholdCoreRepo householdCoreRepo;
  final finance_household.FinanceHouseholdRepo financeHouseholdRepo;
  final ProjectHouseholdRepo projectHouseholdRepo;
  final LibraryUserRepo libraryUserRepo;

  Application()
      : householdCoreRepo = HouseholdCoreRepo(),
        financeHouseholdRepo = finance_household.FinanceHouseholdRepo(),
        projectHouseholdRepo = ProjectHouseholdRepo(),
        libraryUserRepo = LibraryUserRepo() {

    var projectDomainModels = householdCoreRepo
        .getDomainModels("Household");
    var projectModelEntries =
        projectDomainModels?.getModelEntries("Household");


  }

  Domains get domains {
    return Domains();
      // ..addFrom(householdCoreRepo.domains)
      // ..addFrom(financeHouseholdRepo.domains)
      // ..addFrom(projectHouseholdRepo.domains);
      // ..addFrom(libraryUserRepo.domains);
  }
}
