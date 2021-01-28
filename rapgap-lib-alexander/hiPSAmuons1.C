using namespace RooFit;

void hiPSAmuons1(){

//Instantiate some variables
        istringstream curstring;
        string temp_string,temp,temp_v,temp_p;
        float enf,prob,x,y,z,t,zero1,zero2,zero3,totalTracks,zero4;
        Int_t evt_n,event_scale,alphaQCD,alphaQED,process_ID,vertex,vertex_num,rand,weight;
        string temp_string_2,temp_2,temp_v_2,temp_p_2;
        TDatabasePDG *massFinder = new TDatabasePDG();
        TRandom3 *gRandom = new TRandom3();
        int atBeginning = 0;
        int eventCounter = 0;

//Create a histogram for the HI probability (normalize the histogram of the photon spectrum).
	string filename = "photonDist_v1.txt"; //input
	ifstream infile(filename.c_str());
	if (! infile.is_open()) { cout << "\t ERROR: I can not open \"" << filename << "\"" << endl; return; }
	//TH1F *enf_HI = new TH1F("enf_HI","enf_HI",2000,0.002,1.0);
	TH1F *enf_HI = new TH1F("enf_HI","enf_HI",8501,.007499,.050002);
	getline(infile,temp_string); // The very first line is useless
	while (getline(infile,temp_string)) {

		curstring.clear();
		curstring.str(temp_string);

		curstring >> enf >> prob;

		TAxis *xaxis = enf_HI->GetXaxis();
		Int_t binx = xaxis->FindBin(enf);
		enf_HI->SetBinContent(binx,prob);

	}
	Double_t norm = enf_HI->GetEntries();
	//enf_HI->Scale(1/norm);
//Let's create an output Tree and put muons inside.
//
TLorentzVector jv,mu0,mu1,pcv;
  TString outFileName="dimuon11_test.root";
  TFile *newfile = new TFile(outFileName,"recreate");
  newfile->cd();
  TTree *muon_tree = new TTree("muon_tree","Generated muons");
        Double_t C[2], PX[2], PZ[2], PY[2], PTm[2];
        Double_t PDGd[100], Phid[100],  Ptd[100];
        Double_t Etad[100]={0};
        Double_t PT[1], M[1], Y[1];
        TBranch *br_px=muon_tree->Branch("px",PX,"PX[2]/D");
        TBranch *br_py=muon_tree->Branch("py",PY,"PY[2]/D");
        TBranch *br_pz=muon_tree->Branch("pz",PZ,"PZ[2]/D");
        TBranch *br_pt=muon_tree->Branch("pt",PT,"PT[1]/D");
        TBranch *br_phid=muon_tree->Branch("phid",Phid,"Phid[100]/D");
        TBranch *br_etad=muon_tree->Branch("etad",Etad,"Etad[100]/D");
        TBranch *br_ptd=muon_tree->Branch("ptd",Ptd,"Ptd[100]/D");
        TBranch *br_pdgd=muon_tree->Branch("pdgd",PDGd,"PDGd[100]/D");
        TBranch *br_y=muon_tree->Branch("y",Y,"Y[1]/D");
        TBranch *br_m=muon_tree->Branch("m",M,"M[1]/D");
        TBranch *br_c=muon_tree->Branch("c",C,"C[2]/D");


//Open the MC, my own custom format, from RAPGAP
	//string filename_2 = "../../rap_pd/rapgap_try00/hepmcgk.dat"; //input
//	string filename_2 = "/eos/user/a/abylinki/hepmc_gkiexc.dat"; //input
	string filename_2 = "/eos/user/a/abylinki/jpsi1.dat"; //input
//	string filename_2 = "../rapgap_try00/hepmc_gkiexc.dat"; //input
	ifstream infile_2(filename_2.c_str());
	if (! infile_2.is_open()) { cout << "\t ERROR: I can not open \"" << filename_2 << "\"" << endl; return; }
//For my own tests, my own custom format output
        char outfilename[100];
        sprintf(outfilename,"hepmc_gk_HI_new.dat");
        ofstream output(outfilename);
        output <<  "HepMC::IO_Ascii-START_EVENT_LISTING" << endl;
//For CMSSW, the HEPMC format output
        char outfilename_2[100];
       	//TString outfilename_2;
        sprintf(outfilename_2,"/eos/user/a/abylinki/rgh/hepmc_HI_0.dat");
        ofstream output_2(outfilename_2);
        output_2 <<  "HepMC::IO_Ascii-START_EVENT_LISTING" << endl;

        TF1 *f = new TF1("myfunc_enf","[0]*(1/0.0025)*( ((1+(1-x)^2)/x)-(2*x*0.000511*0.000511)*(1/0.0025))",0.002,1.0);
        f->SetParameter(0,0.2462);
   	//TH1F *enf_Elec=new TH1F("enf_Elec","enf_Elec",2000,0.002,1.0);
   	TH1F *enf_Elec=new TH1F("enf_Elec","enf_Elec",8501,.007499,.050002);
   	enf_Elec->FillRandom("myfunc_enf",10000000);

//Now, normalize both probabilities such that enf=0.002 has "prob"=1
//        Double_t norm_HI = enf_HI->GetEntries();
//        enf_HI->Scale(1/norm_HI);

	TAxis *startElec_XAxis = enf_Elec->GetXaxis();
	Int_t startElec_BinX = startElec_XAxis->FindBin(.0075);
	Float_t startElec_Cont = enf_Elec->GetBinContent(startElec_BinX);
	enf_Elec->Scale(1/startElec_Cont);

        TAxis *startHI_XAxis = enf_HI->GetXaxis();
        Int_t startHI_BinX = startHI_XAxis->FindBin(.0075);
        Float_t startHI_Cont = enf_HI->GetBinContent(startHI_BinX);
        enf_HI->Scale(1/startHI_Cont);

//	cout<<"enf_Elec first bin "<<enf_Elec->GetBinContent(1)<<endl;
//	cout<<"enf_HI first bin "<<enf_HI->GetBinContent(0)<<endl;


//Draw the photon spectra side by side.
	gStyle->SetOptStat(0);
	TCanvas* c1 = new TCanvas("c1","Photon Spectrum",800,800);
	enf_Elec->SetTitle("Photon Spectrum");
        enf_Elec->GetXaxis()->SetTitle("Energy Fraction");
        enf_Elec->GetYaxis()->SetTitle("Probability per Bin");
	enf_Elec->SetLineWidth(2);
	enf_HI->SetLineWidth(2);
	enf_Elec->SetLineColor(kBlue);
	enf_HI->SetLineColor(kRed);
	enf_Elec->Draw("HIST");
	enf_HI->Draw("HIST&&SAME");
        enf_Elec->GetYaxis()->SetTitleOffset(1.2);
   	TLegend *leg1=new TLegend(0.6,0.75,0.88,0.85);
   	leg1->SetTextFont(72);
   	leg1->SetTextSize(0.02);
   	leg1->AddEntry(enf_Elec,"Electron","l");
   	leg1->AddEntry(enf_HI,"Heavy-Ion","l");
   	leg1->Draw();
//Draw the ratio of the spectra, HI/elec
	TCanvas* c2 = new TCanvas("c2","Spectra Ratio",800,800);
	TH1F* enf_Ratio = (TH1F*)enf_HI->Clone();
	enf_Ratio->SetTitle("Energy-Fraction Ratio");
        enf_Ratio->GetXaxis()->SetTitle("Energy Fraction");
        enf_Ratio->GetYaxis()->SetTitle("Probability Ratio per Bin");
	enf_Ratio->SetLineWidth(2);
	enf_Ratio->SetLineColor(kBlue);
	enf_Ratio->Divide(enf_Elec);
	enf_Ratio->Draw("HIST");
        enf_Ratio->GetYaxis()->SetTitleOffset(1.2);
        TLegend *leg2=new TLegend(0.6,0.80,0.88,0.85);
        leg2->SetTextFont(72);
        leg2->SetTextSize(0.02);
        leg2->AddEntry(enf_Ratio,"Heavy-Ion / Electron","l");
        leg2->Draw();	
	Float_t filec=0;
	Int_t bflc=0;
	getline(infile_2,temp_string_2);
	Int_t muonm=0;
	Int_t muonp=0;
	Int_t dimuon=0;
	Int_t dimuoncheck=0;
	Int_t pc=0;
	//while (getline(infile_2,temp_string_2)) {
//	while (eventCounter<1678999) {
//	while (eventCounter<285999) {
//	while (eventCounter<999999) {
	while (eventCounter<99999) {
	getline(infile_2,temp_string_2);
		curstring.clear(); 
		curstring.str(temp_string_2);
		if(strstr(temp_string_2.c_str(),"E")) {
					eventCounter++;
					if(eventCounter%1000==0)cout <<eventCounter<<endl;
				TAxis *xaxis_HI = enf_HI->GetXaxis();
				TAxis *xaxis_Elec = enf_Elec->GetXaxis();

				Int_t binx_HI = xaxis_HI->FindBin(enf);
				Int_t binx_Elec = xaxis_Elec->FindBin(enf);

				Double_t enfProb_HI = enf_HI->GetBinContent(binx_HI);
				Double_t enfProb_Elec = enf_Elec->GetBinContent(binx_Elec);
	//	if(muonp==1&&muonm==1&&Y[0]>-4&&Y[0]<-2.5 && PTm[0]>.8 && PTm[1]>.8)
		 if(Y[0]>-4&&Y[0]<-2.5 && dimuoncheck){
				if(gRandom->Rndm() < (enfProb_HI/enfProb_Elec))	muon_tree->Fill();
		}
			//if(dimuoncheck==0)cout<<"No J/Psi in an event"<<endl;
		PX[0]=-99999;
		PY[0]=-99999;
		PZ[0]=-99999;
		C[0]=0;
		PX[1]=-99999;
		PY[1]=-99999;
		PZ[1]=-99999;
		C[1]=0;
		PT[0]=-1;
		PTm[1]=-1;
		PTm[0]=-1;
		Y[0]=-99999;
		M[0]=-1;
			for (Int_t i=0;i<100;i++){
				Phid[i]=-9;
				Etad[i]=-9;
				Ptd[i]=-1;
				PDGd[i]=-999;	
			}
		muonp=0;
		muonm=0;
		dimuoncheck=0;	
		pc=0;
			atBeginning = 1;
			curstring >> temp_2 >> evt_n >> event_scale >> alphaQCD >> alphaQED >> process_ID >> vertex >> vertex_num >> rand >> weight;
		} else if(strstr(temp_string_2.c_str(),"V")) {
			curstring >> temp_v_2 >> x >> y >> z >> t >> zero1 >> zero2 >> zero3 >> totalTracks >> zero4;
		} else if(strstr(temp_string_2.c_str(),"P"))  {
			int useless, part_n, pdg_id, status;
			float px, py, pz, energy, enf, q2, xel, xpr;
			string sss;
			curstring >> temp_p_2 >> useless >> pdg_id >> px >> py >> pz >> energy >> status >> sss >> q2 >> enf >> xel >> xpr;
		//	cout << pdg_id<<endl;
			if (pdg_id == 13) {
				if (muonm) cout << "more than one muonm"<<endl;
				muonm=1;
				mu0.SetPxPyPzE(px,py,pz,energy);
				PTm[0]=mu0.Pt();
				PX[0]=px;
				PY[0]=py;
				PZ[0]=pz;
				C[0]=-1;
				if (muonp) dimuon++;
			}
			if (pdg_id == -13) {
				if (muonp) cout << "more than one muonp"<<endl;
				muonp=1;
				mu1.SetPxPyPzE(px,py,pz,energy);
				PTm[1]=mu1.Pt();
				PX[1]=px;
				PY[1]=py;
				PZ[1]=pz;
				C[1]=1;
				if (muonm)dimuon++;
			}
			if (pdg_id == 443) {
				jv.SetPxPyPzE(px,py,pz,energy);
				PT[0]=jv.Pt();
				M[0]=jv.M();
				Y[0]=jv.Rapidity();
				dimuoncheck=1;
			}
			if (status==1 && pdg_id != 13 && pdg_id != - 13 && pdg_id != 2212 && pdg_id != -11){
				pcv.SetPxPyPzE(px,py,pz,energy);
				Phid[pc]=pcv.Phi();	
				Etad[pc]=pcv.Eta();	
				Ptd[pc]=pcv.Pt();	
				PDGd[pc]=pdg_id;	
				pc++;
			}
			//	if (muonm==1&&muonp==1) cout << "Dimuon found!"<<endl;
			//	if (muonm==1&&muonp==1) dimuon++;
			if(atBeginning == 1){
				bflc++;
//This must be changed for our needs. "enf" must come from the fitting function.
//Also need to fit a new function to the resulting curve, enf_HI_MC.
//				cout<<enfProb_HI/enfProb_Elec<<endl;		
//				if(gRandom->Rndm()){// < (enfProb_HI/enfProb_Elec)){
//					eventCounter++;
//					if(eventCounter%5000==0){
//					filec++;
//		c14->Print(Form("PT25/event_%d.png",(int) i));
//        output_2 << "HepMC::IO_Ascii-END_EVENT_LISTING" << endl;
//	output_2.close();
//      	sprintf(outfilename_2,Form("/eos/user/a/abylinki/rgh/hepmc_HI_%d.dat",(int) filec));
//	        output_2.open(outfilename_2);
//		cout << "Events: "<<bflc<<"  Open File: "<<filec<<endl; 
//	        output_2 <<  "HepMC::IO_Ascii-START_EVENT_LISTING" << endl;
//					}

//					output<<"E "<<evt_n<<" "<<event_scale<<" "<<alphaQCD<<" "<<alphaQED<<" "<<process_ID<<" "<<vertex<<" "<<vertex_num<<" 0 0"<<endl;
//					output<<"V "<<x<<" "<<y<<" "<<z<<" "<<t<<" "<<zero1<<" "<<zero2<<" "<<zero3<<" "<<totalTracks<<" "<<zero4<<endl;
//					output<<"P "<<useless<<" "<<pdg_id<<" "<<px<<" "<<py<<" "<<pz<<" "<<energy<<" "<<status<<" "<<sss<<" "<<q2<<" "<<enf<<" "<<xel<<" "<<xpr<<endl;

//                                        output_2<<"E "<<evt_n<<" "<<event_scale<<" "<<alphaQCD<<" "<<alphaQED<<"  "<<process_ID<<" "<<vertex<<" "<<vertex_num<<" 0 0"<<endl;
//                                        output_2<<"V "<<x<<" "<<y<<" "<<z<<" "<<t<<" "<<zero1<<" "<<zero2<<" "<<zero3<<" "<<totalTracks<<" "<<zero4<<endl;
//                                        output_2<<"P "<<useless<<" "<<pdg_id<<" "<<px<<" "<<py<<" "<<pz<<" "<<energy<<" "<<status<<" 0 0 0 0"<<endl;

//					Int_t numTracks = totalTracks-1;
//					for(int i = 0; i<numTracks; i++){
//						getline(infile_2,temp_string_2);
//						curstring.clear();
//						curstring.str(temp_string_2);
//						curstring >> temp_p_2 >> useless >> pdg_id >> px >> py >> pz >> energy >> status >> sss >> q2 >> enf >> xel >> xpr;
//						output<<"P "<<useless<<" "<<pdg_id<<" "<<px<<" "<<py<<" "<<pz<<" "<<energy<<" "<<status<<" "<<sss<<" "<<q2<<" "<<enf<<" "<<xel<<" "<<xpr<<endl;
  //                                              output_2<<"P "<<useless<<" "<<pdg_id<<" "<<px<<" "<<py<<" "<<pz<<" "<<energy<<" "<<status<<" 0 0 0 0"<<endl;
//					}
//				}

			}
			atBeginning=0;
		}
	}
//	muon_tree->Write();
	cout << bflc<<"\t"<<eventCounter<<endl;
        output << "HepMC::IO_Ascii-END_EVENT_LISTING" << endl;
        output_2 << "HepMC::IO_Ascii-END_EVENT_LISTING" << endl;

	TFile *outputFile = new TFile("genhist_hiApplicator9.root","RECREATE");
	c1->Write();
	c2->Write();

	enf_HI->Write();
	enf_Elec->Write();
cout << dimuon<<" Dimuons Found"<<endl;
	outputFile->Save();
	outputFile->Close();
	newfile->Write();
	newfile->Close();
}
