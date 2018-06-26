{
  TString incpath(Form("%s/.local/include", gSystem->Getenv("HOME")));
  gSystem->AddIncludePath(Form("-I%s", incpath.Data()));
  gInterpreter->AddIncludePath(incpath.Data());
  gROOT->ProcessLine("#include \"range/v3/all.hpp\"");
  gROOT->ProcessLine("auto xrange = ranges::view::indices;");
}
