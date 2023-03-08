part of ednet_core;

String genEDNetWeb(Model model) {
  Domain domain = model.domain;

  var sc = ' \n';
  sc = '${sc}// web/${domain.codeLowerUnderscore}/${model.codeLowerUnderscore}/'
       '${domain.codeLowerUnderscore}_${model.codeLowerUnderscore}_web.dart \n';
  sc = '${sc} \n';

  sc = '$sc\nimport "package:ednet_core/ednet_core.dart"; \n';
  sc = '${sc} \n';
  sc = '${sc}import "package:ednet_core_default_app/ednet_core_default_app.dart"; \n';
  sc = '${sc}import "package:${domain.codeLowerUnderscore}_'
       '${model.codeLowerUnderscore}/${domain.codeLowerUnderscore}_'
       '${model.codeLowerUnderscore}.dart"; \n';
  sc = '${sc} \n';

  sc = '${sc}void initData(CoreRepository repository) { \n';
  sc = '${sc}   ${domain.code}Domain? ${domain.codeFirstLetterLower}Domain = '
       'repository.getDomainModels("${domain.code}") as ${domain.code}Domain?; \n';
  sc = '${sc}   ${model.code}Model? ${model.codeFirstLetterLower}Model = '
       '${domain.codeFirstLetterLower}Domain?.'
       'getModelEntries("${model.code}") as ${model.code}Model?; \n';
  sc = '${sc}   ${model.codeFirstLetterLower}Model?.init(); \n';
  sc = '${sc}   ${model.codeFirstLetterLower}Model?.display(); \n';
  sc = '${sc}} \n';
  sc = '${sc} \n';

  sc = '${sc}void showData(CoreRepository repository) { \n';
  sc = '${sc}   // var mainView = View(document, "main"); \n';
  sc = '${sc}   // mainView.repo = repository; \n';
  sc = '${sc}   // new RepoMainSection(mainView); \n';
  sc = '${sc}   print("not implemented"); \n';
  sc = '${sc}} \n';
  sc = '${sc} \n';

  sc = '${sc}void main() { \n';
  sc = '${sc}  var repository = CoreRepository(); \n';
  sc = '${sc}  initData(repository); \n';
  sc = '${sc}  showData(repository); \n';
  sc = '${sc}} \n';
  sc = '${sc} \n';

  return sc;
}
