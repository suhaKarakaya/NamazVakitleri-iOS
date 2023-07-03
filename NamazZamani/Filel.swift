//
//  Filel.swift
//  NamazZamani
//
//  Created by Süha Karakaya on 18.05.2023.
//

import Foundation


public class deneme {
    
    if selectedTechnicalEmployeeValue == 1 { // Çalışan Teknik Yetenek mi? - Evet
        if teknikYetenekAciklamaField.textColor == .lightGray || teknikYetenekAciklamaField.text == nil { // Teknik Yetenek Açıklama Dolu mu? - Hayır
            showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Information"), message: getAppMessage("Mobile.Talent.Potential.Alert.Message.FillExplanationFieldTechnicalTalent"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
            return false
        } else { // Teknik Yetenek Açıklama Dolu mu? - Evet
            if selectedPotentialId == 49062 || selectedPotentialId == 49063 { // Yüksek Potansiyel veya Potansiyel mi? - Evet
                if PMConstants.potansiyelYedekPozisyonSelectedData.hazir.count == 0 && PMConstants.potansiyelYedekPozisyonSelectedData.kisa.count == 0 && PMConstants.potansiyelYedekPozisyonSelectedData.orta.count == 0 && PMConstants.potansiyelYedekPozisyonSelectedData.uzun.count == 0 {
                    if canBeBackupWithinOyak != 0 { // OYAK İçinde Bir Pozisyonda Yedek Olabilir mi? Seçili mi? - Evet
                        if canBeBackupWithinOyak == 1 { // Yedek Seçilebilir mi? - Evet
                            if (selectedEmployeeLeaveRiskLevelId == 0 || selectedPositionFillDifficultyLevelId == 0) && selectedPotentialId != 49065 { // Her İki Risk Alanı da Dolu mu? - Hayır (Pozisyonda Yeni olmayan alanlar için kontrol edilir)
                                showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Information"), message: getAppMessage("Mobile.Talent.PotentialEvaluation.Alert.Message.CompleteRiskAssesment"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                                return false
                            } else { // Her İki Risk Alanı da Dolu mu? - Evet
                                // taslağa kaydet, tamamla, güncelle butonlarının akışı yapılır.
                            }
                        } else { // Yedek Seçilebilir mi? - Hayır
                            showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Information"), message: getAppMessage("Mobile.Talent.Potential.Text.IfThereEmployeeCanBackup"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                        }
                    } else { // OYAK İçinde Bir Pozisyonda Yedek Olabilir mi? Seçili mi? - Hayır
                        showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Information"), message: getAppMessage("Mobile.Talent.Potential.Alert.Message.PositionSuggestionsemployeeBackupPositionWithinOYAK"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                    }
                } else {
                    if (selectedEmployeeLeaveRiskLevelId == 0 || selectedPositionFillDifficultyLevelId == 0) && selectedPotentialId != 49065 { // Her İki Risk Alanı da Dolu mu? - Hayır (Pozisyonda Yeni olmayan alanlar için kontrol edilir)
                        showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Information"), message: getAppMessage("Mobile.Talent.PotentialEvaluation.Alert.Message.CompleteRiskAssesment"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                        return false
                    } else { // Her İki Risk Alanı da Dolu mu? - Evet
                        // taslağa kaydet, tamamla, güncelle butonlarının akışı yapılır.
                    }
                }
            } else { // Yüksek Potansiyel veya Potansiyel mi? - Hayır
                if selectedPotentialId == 49064 { // Sınırlı Potansiyel mi? - Evet
                    if (selectedEmployeeLeaveRiskLevelId == 0 || selectedPositionFillDifficultyLevelId == 0) && selectedPotentialId != 49065 { // Her İki Risk Alanı da Dolu mu? - Hayır (Pozisyonda Yeni olmayan alanlar için kontrol edilir)
                        showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Information"), message: getAppMessage("Mobile.Talent.PotentialEvaluation.Alert.Message.CompleteRiskAssesment"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                        return false
                    } else { // Her İki Risk Alanı da Dolu mu? - Evet
                        // taslağa kaydet, tamamla, güncelle butonlarının akışı yapılır.
                    }
                } else { // Sınırlı Potansiyel mi? - Hayır
                    // taslağa kaydet, tamamla, güncelle butonlarının akışı yapılır.
                }
            }
        }
    } else { // Çalışan Teknik Yetenek mi? - Hayır
        if selectedPotentialId == 49062 || selectedPotentialId == 49063 { // Yüksek Potansiyel veya Potansiyel mi? - Evet
            if PMConstants.potansiyelYedekPozisyonSelectedData.hazir.count == 0 && PMConstants.potansiyelYedekPozisyonSelectedData.kisa.count == 0 && PMConstants.potansiyelYedekPozisyonSelectedData.orta.count == 0 && PMConstants.potansiyelYedekPozisyonSelectedData.uzun.count == 0 {
                if canBeBackupWithinOyak != 0 { // OYAK İçinde Bir Pozisyonda Yedek Olabilir mi? Seçili mi? - Evet
                    if canBeBackupWithinOyak == 1 { // Yedek Seçilebilir mi? - Evet
                        if (selectedEmployeeLeaveRiskLevelId == 0 || selectedPositionFillDifficultyLevelId == 0) && selectedPotentialId != 49065 { // Her İki Risk Alanı da Dolu mu? - Hayır (Pozisyonda Yeni olmayan alanlar için kontrol edilir)
                            showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Information"), message: getAppMessage("Mobile.Talent.PotentialEvaluation.Alert.Message.CompleteRiskAssesment"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                            return false
                        } else { // Her İki Risk Alanı da Dolu mu? - Evet
                            // taslağa kaydet, tamamla, güncelle butonlarının akışı yapılır.
                        }
                    } else { // Yedek Seçilebilir mi? - Hayır
                        showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Information"), message: getAppMessage("Mobile.Talent.Potential.Text.IfThereEmployeeCanBackup"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                    }
                } else { // OYAK İçinde Bir Pozisyonda Yedek Olabilir mi? Seçili mi? - Hayır
                    showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Information"), message: getAppMessage("Mobile.Talent.Potential.Alert.Message.PositionSuggestionsemployeeBackupPositionWithinOYAK"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                }
            } else {
                if (selectedEmployeeLeaveRiskLevelId == 0 || selectedPositionFillDifficultyLevelId == 0) && selectedPotentialId != 49065 { // Her İki Risk Alanı da Dolu mu? - Hayır (Pozisyonda Yeni olmayan alanlar için kontrol edilir)
                    showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Information"), message: getAppMessage("Mobile.Talent.PotentialEvaluation.Alert.Message.CompleteRiskAssesment"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                    return false
                } else { // Her İki Risk Alanı da Dolu mu? - Evet
                    // taslağa kaydet, tamamla, güncelle butonlarının akışı yapılır.
                }
            }
        } else { // Yüksek Potansiyel veya Potansiyel mi? - Hayır
            if selectedPotentialId == 49064 { // Sınırlı Potansiyel mi? - Evet
                if (selectedEmployeeLeaveRiskLevelId == 0 || selectedPositionFillDifficultyLevelId == 0) && selectedPotentialId != 49065 { // Her İki Risk Alanı da Dolu mu? - Hayır (Pozisyonda Yeni olmayan alanlar için kontrol edilir)
                    showDefaultAlert(title: getAppMessage("Mobile.Global.Alert.Title.Information"), message: getAppMessage("Mobile.Talent.PotentialEvaluation.Alert.Message.CompleteRiskAssesment"), buttonTitle: getAppMessage("Mobile.Global.Button.Ok"), view: self)
                    return false
                } else { // Her İki Risk Alanı da Dolu mu? - Evet
                    // taslağa kaydet, tamamla, güncelle butonlarının akışı yapılır.
                }
            } else { // Sınırlı Potansiyel mi? - Hayır
                // taslağa kaydet, tamamla, güncelle butonlarının akışı yapılır.
            }
        }
    }
}
