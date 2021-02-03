    % Structure de données pour EKF
    if ((CapteurUtilise == 1)|(CapteurUtilise == 6))
        if isempty(DonneesLocalisationEKF(1).X_E)
            DonneesLocalisationEKF(1).X_E                       =   VehiculeNL.X_E;
            DonneesLocalisationEKF(1).P_E                       =   VehiculeNL.P_E;
            DonneesLocalisationEKF(1).Temps                     =   VehiculeNL.TempsCourant;
            DonneesLocalisationEKF(1).CapteurUtilise            =   CapteurUtilise;
        else
            Longueur=size(DonneesLocalisationEKF,2);
            DonneesLocalisationEKF(Longueur+1).X_E              =   VehiculeNL.X_E;
            DonneesLocalisationEKF(Longueur+1).P_E              =   VehiculeNL.P_E;
            DonneesLocalisationEKF(Longueur+1).Temps            =   VehiculeNL.TempsCourant;
            DonneesLocalisationEKF(Longueur+1).CapteurUtilise   =   CapteurUtilise;
        end;
    end;

