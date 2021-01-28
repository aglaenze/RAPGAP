using namespace RooFit;

void plotmuons(){
	TH1F *mu_pt0 = new TH1F("mu_pt0","mu_pt0",40,0,2.5);
	TH1F *mu_pt1 = new TH1F("mu_pt1","mu_pt1",40,0,2.5);
	TFile *f0 = new TFile("dimuon9.root");
	TFile *f1 = new TFile("dimuon10.root");
	TTree *MuTree0 = (TTree*)f0->Get("muon_tree");
	TTree *MuTree1 = (TTree*)f1->Get("muon_tree");
	Double_t Pt0[1];
	Double_t Pt1[1];
	TBranch *b_Pt0;   
	TBranch *b_Pt1;   
	MuTree0->SetBranchAddress("pt", Pt0, &b_Pt0);
	MuTree1->SetBranchAddress("pt", Pt1, &b_Pt1);
	Int_t nevt0 = MuTree0->GetEntries(); 
	Int_t nevt1 = MuTree1->GetEntries(); 
	for (int i=0; i<nevt0; i++) {
		MuTree0->GetEntry(i);
		mu_pt0->Fill(Pt0[0]*Pt0[0]);
	}
	for (int i=0; i<nevt1; i++) {
		MuTree1->GetEntry(i);
		mu_pt1->Fill(Pt1[0]*Pt1[0]);
	}
	mu_pt0->SetLineColor(2);
//Draw the ratio of the spectra, HI/elec
	TCanvas* c2 = new TCanvas("c2","Spectra Ratio",800,800);
	c2->SetLogy();
	mu_pt0->GetYaxis()->SetTitle("Events");
	mu_pt0->GetXaxis()->SetTitle("t [GeV^{2}]");
	mu_pt0->Scale(.1);
	mu_pt0->GetYaxis()->SetRangeUser(1,1e7);
//	mu_pt0->Add(mu_pt1);
	mu_pt0->Draw("HIST");
	mu_pt1->Draw("HISTSAME");
	c2->Print("dimuon.png");

}
