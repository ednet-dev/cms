import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/hausehold/finance/lib/finance_household.dart'
    as finance_household;
import 'package:ednet_one/generated/hausehold/hausehold/lib/household_core.dart'
    as household_core;
import 'package:ednet_one/generated/hausehold/member/lib/member_household.dart'
    as member_household;
import 'package:ednet_one/generated/hausehold/project/lib/project_household.dart';
import 'package:ednet_one/generated/user/library/lib/library_user.dart';

class OneApplication {
  final Domains _domains = Domains();

  OneApplication() {
    _initializeDomains();
  }

  void _initializeDomains() {
    final householdCoreRepo = household_core.HouseholdCoreRepo();
    final financeHouseholdRepo = finance_household.FinanceHouseholdRepo();
    final projectHouseholdRepo = ProjectHouseholdRepo();
    final libraryUserRepo = LibraryUserRepo();
    final memberHouseholdRepo = member_household.MemberHouseholdRepo();

    final householdDomain =
        projectHouseholdRepo.getDomainModels("Project") as ProjectDomain;
    final projectModel =
        householdDomain.getModelEntries("Household") as HouseholdModel;
    projectModel.simulate();

    final userDomain =
        libraryUserRepo.getDomainModels("Library") as LibraryDomain;
    final libraryModel = userDomain.getModelEntries("User") as UserModel;
    libraryModel.simulate();

    final financeDomain = financeHouseholdRepo.getDomainModels("Finance")
        as finance_household.FinanceDomain;
    final financeModel = financeDomain.getModelEntries("Household")
        as finance_household.HouseholdModel;
    financeModel.simulate();

    final memberDomain = memberHouseholdRepo.getDomainModels("Member")
        as member_household.MemberDomain;
    final memberModel = memberDomain.getModelEntries("Household")
        as member_household.HouseholdModel;
    memberModel.simulate();

    final householdCoreDomain = householdCoreRepo.getDomainModels("Household")
        as household_core.HouseholdDomain;
    final householdCoreModel =
        householdCoreDomain.getModelEntries("Core") as household_core.CoreModel;
    householdCoreModel.simulate();

    _domains
      ..add(householdDomain.domain)
      ..add(userDomain.domain)
      ..add(financeDomain.domain)
      ..add(memberDomain.domain)
      ..add(householdCoreDomain.domain);
  }

  Domains get domains => _domains;
}
