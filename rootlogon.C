{
  TString incpath(Form("%s/.local/include", gSystem->Getenv("HOME")));
  gSystem->AddIncludePath(Form("-I%s", incpath.Data()));
  gInterpreter->AddIncludePath(incpath.Data());

  // provide python 2 like `xrange`
  // usage:
  // for (auto i: xrange(15)) {
  //   std::cout << i << '\n';
  // }
  gROOT->ProcessLine("#include \"range/v3/all.hpp\"");
  gROOT->ProcessLine("auto xrange = ranges::view::indices;");

  // provide python like `type`
  // usage:
  // auto foo = bar();
  // std::cout << type(foo) << std::endl;
  gROOT->ProcessLine("#include <boost/type_index.hpp>");
  gROOT->ProcessLine("template <typename T> auto type(T) { return boost::typeindex::type_id_with_cvr<T>().pretty_name(); }");
}
