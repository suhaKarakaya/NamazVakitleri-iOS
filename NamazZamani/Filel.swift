//
//  Filel.swift
//  NamazZamani
//
//  Created by Süha Karakaya on 18.05.2023.
//

import Foundation


public class deneme {
    
    if buttonType == .saveDraft {
        startLoading()
        let formObject = createFormObject(potansiyelStatus: 2)
        
        APIClient.savePotentialEvaluate(potentialEvaluate: formObject) { (response) in
            switch response {
            case .success(let result):
                stopLoading()
                
                self.setEvaluationIds(result.Data.ID_TL_POTANTIAL_EVALUATE, result.Data.UID_TL_POTANTIAL_EVALUATE, result.Data.UID_TL_EVALUATION_PERIOD)
                
                startLoading()
                APIClient.savePotentialEvaluateOrganizationsList(self.createPotentialEvaluateOrganizationsList(result.Data)) { (response) in
                    switch response {
                    case .success(let result):
                        stopLoading()
                        if result.Data.IsSuccess {
                            showDefaultAlertWithCompletion(title: getAppMessage("Mobile.Global.Alert.Title.Success"), message: getAppMessage("Mobile.Global.Alert.Message.SuccessfulTransaction"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self) {
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            var errorMessage = ""
                            for error in result.Data.ErrorMessage {
                                errorMessage = errorMessage + " " + error
                            }
                            
                            showDefaultAlertWithCompletion(title: getAppMessage("Mobile.Global.Alert.Title.Success"), message: errorMessage, buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self) {
                                
                            }
                        }
                        break
                    case .failure(_):
                        stopLoading()
                        showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Error"), message: getAppMessage("Mobile.Global.Alert.Message.ErrorOccurred"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                        break
                    }
                }
                break
            case .failure(_):
                stopLoading()
                showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Error"), message: getAppMessage("Mobile.Global.Alert.Message.ErrorOccurred"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
            }
        }
    } else if buttonType == .complete {
        showConfirmationAlertWithCompletion(title: getAppMessage("Mobile.Global.Alert.Title.Information"), message: getAppMessage("Mobile.Talent.Potential.Alert.Message.AreYouSureCompletePotentialAssessmentEmployee"), cancelTitle: getAppMessage("Mobile.Global.Alert.Button.Cancel"), defaultTitle: getAppMessage("Mobile.Global.Button.Ok") , view: self) { (confirm) in
            if confirm {
                if self.potansiyelStatu == PMConstants.PotentialStatus.waiting.id {
                    let formObject = self.createFormObject(potansiyelStatus: 2)
                    
                    APIClient.savePotentialEvaluate(potentialEvaluate: formObject) { (response) in
                        switch response {
                        case .success(let result):
                            
                            self.setEvaluationIds(result.Data.ID_TL_POTANTIAL_EVALUATE, result.Data.UID_TL_POTANTIAL_EVALUATE, result.Data.UID_TL_EVALUATION_PERIOD)
                            
                            stopLoading()
                            startLoading()
                            APIClient.savePotentialEvaluateOrganizationsList(self.createPotentialEvaluateOrganizationsList(result.Data)) { (response) in
                                switch response {
                                case .success(let result):
                                    if result.Data.IsSuccess {
                                        let formObject = self.createFormObject(potansiyelStatus: 4)
                                        
                                        APIClient.savePotentialEvaluate(potentialEvaluate: formObject) { (response) in
                                            switch response {
                                            case .success(_):
                                                stopLoading()
                                                showDefaultAlertWithCompletion(title: getAppMessage("Mobile.Global.Alert.Title.Success"), message: getAppMessage("Mobile.Global.Alert.Message.SuccessfulTransaction"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self) {
                                                    self.dismiss(animated: true, completion: nil)
                                                }
                                                break
                                            case .failure(_):
                                                stopLoading()
                                                showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Error"), message: getAppMessage("Mobile.Global.Alert.Message.ErrorOccurred"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                                            }
                                        }
                                    } else {
                                        var errorMessage = ""
                                        for error in result.Data.ErrorMessage {
                                            errorMessage = errorMessage + " " + error
                                        }
                                        
                                        showDefaultAlertWithCompletion(title: getAppMessage("Mobile.Global.Alert.Title.Success"), message: errorMessage, buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self) {
                                            
                                        }
                                    }
                                    break
                                case .failure(_):
                                    stopLoading()
                                    showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Error"), message: getAppMessage("Mobile.Global.Alert.Message.ErrorOccurred"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                                    break
                                }
                            }
                            break
                        case .failure(_):
                            stopLoading()
                            showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Error"), message: getAppMessage("Mobile.Global.Alert.Message.ErrorOccurred"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                        }
                    }
                } else {
                    let formObject = self.createFormObject(potansiyelStatus: 4)
                    
                    APIClient.savePotentialEvaluate(potentialEvaluate: formObject) { (response) in
                        switch response {
                        case .success(let result):
                            
                            self.setEvaluationIds(result.Data.ID_TL_POTANTIAL_EVALUATE, result.Data.UID_TL_POTANTIAL_EVALUATE, result.Data.UID_TL_EVALUATION_PERIOD)
                            
                            stopLoading()
                            APIClient.savePotentialEvaluateOrganizationsList(self.createPotentialEvaluateOrganizationsList(result.Data)) { (response) in
                                switch response {
                                case .success(_):
                                    stopLoading()
                                    showDefaultAlertWithCompletion(title: getAppMessage("Mobile.Global.Alert.Title.Success"), message: getAppMessage("Mobile.Global.Alert.Message.SuccessfulTransaction"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self) {
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                    break
                                case .failure(_):
                                    stopLoading()
                                    showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Error"), message: getAppMessage("Mobile.Global.Alert.Message.ErrorOccurred"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                                }
                            }
                            break
                        case .failure(_):
                            stopLoading()
                            showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Error"), message: getAppMessage("Mobile.Global.Alert.Message.ErrorOccurred"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                        }
                    }
                }
            } else {
                // do nothing
            }
        }
    } else {
        showConfirmationAlertWithCompletion(title: getAppMessage("Mobile.Global.Alert.Title.Information"), message: getAppMessage("Mobile.Talent.Potential.Alert.Message.AreYouSureUpdatePotentialAssessmentEmployee"), cancelTitle: getAppMessage("Mobile.Global.Alert.Button.Cancel"), defaultTitle: getAppMessage("Mobile.Global.Button.Ok") , view: self) { (bool) in
            if bool {
                let formObject = self.createFormObject(potansiyelStatus: 4)
                
                startLoading()
                APIClient.savePotentialEvaluate(potentialEvaluate: formObject) { (response) in
                    switch response {
                    case .success(let result):
                        
                        self.setEvaluationIds(result.Data.ID_TL_POTANTIAL_EVALUATE, result.Data.UID_TL_POTANTIAL_EVALUATE, result.Data.UID_TL_EVALUATION_PERIOD)
                        
                        stopLoading()
                        startLoading()
                        APIClient.savePotentialEvaluateOrganizationsList(self.createPotentialEvaluateOrganizationsList(result.Data)) { (response) in
                            switch response {
                            case .success(let result):
                                stopLoading()
                                if result.Data.IsSuccess {
                                    showDefaultAlertWithCompletion(title: getAppMessage("Mobile.Global.Alert.Title.Success"), message: getAppMessage("Mobile.Global.Alert.Message.SuccessfulTransaction"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self) {
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                } else {
                                    var errorMessage = ""
                                    for error in result.Data.ErrorMessage {
                                        errorMessage = errorMessage + " " + error
                                    }
                                    
                                    showDefaultAlertWithCompletion(title: getAppMessage("Mobile.Global.Alert.Title.Success"), message: errorMessage, buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self) {
                                    }
                                }
                                break
                            case .failure(_):
                                stopLoading()
                                showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Error"), message: getAppMessage("Mobile.Global.Alert.Message.ErrorOccurred"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                                break
                            }
                        }
                        break
                    case .failure(_):
                        stopLoading()
                        showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Error"), message: getAppMessage("Mobile.Global.Alert.Message.ErrorOccurred"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                    }
                }
            }
        }
    }
}
