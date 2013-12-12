#Setting up the correct directory:
cd $CMSSW_BASE/src


#Loading all packages:
addpkg DataFormats/PatCandidates V06-05-06-12
addpkg PhysicsTools/PatAlgos     V08-09-62
addpkg PhysicsTools/PatUtils
addpkg RecoBTag/ImpactParameter V01-04-09-01
addpkg RecoBTag/SecondaryVertex V01-10-06
addpkg RecoBTag/SoftLepton      V05-09-11
addpkg RecoBTag/Configuration   V00-07-05
addpkg RecoBTau/JetTagComputer  V02-03-02
addpkg RecoParticleFlow/PFProducer V15-02-06
addpkg RecoEgamma/EgammaTools       V09-00-01
cvs co -r SE_PhotonIsoProducer_MovedIn    EgammaAnalysis/ElectronTools
cvs co -r SE_PhotonIsoProducer_MovedOut -d EGamma/EGammaAnalysisTools UserCode/EGamma/EGammaAnalysisTools
cd EGamma/EGammaAnalysisTools/data
cat download.url | xargs wget                      
cd ../../../
addpkg RecoMET/METAnalyzers V00-00-08
addpkg DataFormats/METReco V03-03-11-01
addpkg JetMETCorrections/Type1MET V04-06-09-02
cvs co -r 1.7 JetMETCorrections/Type1MET/python/pfMETsysShiftCorrections_cfi.py
addpkg DPGAnalysis/SiStripTools V00-11-17
# from SingleTop CMSSW_5_3_8 recipe
#addpkg DPGAnalysis/Skims V01-00-11-01 
#cvs co -r V00-02-14      DataFormats/StdDictionaries
#cvs co -r V00-00-08      DataFormats/TrackerCommon
#cvs co -r V01-09-05      RecoLocalTracker/SubCollectionProducers          
cvs co -r V00-02-05 -d CMGTools/External UserCode/CMG/CMGTools/External

#Electron iso/ID part:
cvs co -r V00-00-31-EA02 -d EGamma/EGammaAnalysisTools/plugins/  UserCode/EGamma/EGammaAnalysisTools/plugins/ElectronIsolatorFromEffectiveArea.cc
cvs co -r V00-00-31-EA02 -d EGamma/EGammaAnalysisTools/python/   UserCode/EGamma/EGammaAnalysisTools/python/electronIsolatorFromEffectiveArea_cfi.py

setenv OLD '#include "EGamma/EGammaAnalysisTools/interface/ElectronEffectiveArea.h"'
setenv NEW '#include "EgammaAnalysis/ElectronTools/interface/ElectronEffectiveArea.h"'
echo $OLD
echo $NEW
sed "s|$OLD|$NEW|g" EGamma/EGammaAnalysisTools/plugins/ElectronIsolatorFromEffectiveArea.cc > tmp.log
mv tmp.log EGamma/EGammaAnalysisTools/plugins/ElectronIsolatorFromEffectiveArea.cc

setenv OLD 'EgammaAnalysis/ElectronTools/data'
setenv NEW 'EGamma/EGammaAnalysisTools/data'
echo $OLD
echo $NEW
sed "s|$OLD|$NEW|g" EgammaAnalysis/ElectronTools/python/electronIdMVAProducer_cfi.py > tmp.log
mv tmp.log EgammaAnalysis/ElectronTools/python/electronIdMVAProducer_cfi.py


#Adding lhapdf libraries: 
cmsenv
scram setup lhapdffull
cmsenv

#Compilation:
scram b -j 9 > & step1.log &
