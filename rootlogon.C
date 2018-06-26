{
  TString incpath(Form("%s/.local/include",gSystem->Getenv("HOME")));
  gSystem->AddIncludePath(Form("-I%s",incpath.Data()));
  gInterpreter->AddIncludePath(incpath.Data());
}
