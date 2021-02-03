       
        %============================================================================
        % 				AFFICHAGE DE LA POSITION ESTIMEE DU VEHICULE EQUIPE
        %============================================================================
        plot(PisteRoutiere.xc,PisteRoutiere.yc,'k-');
        plot(PisteRoutiere.xg,PisteRoutiere.yg,'k-');
        plot(PisteRoutiere.xd,PisteRoutiere.yd,'k-');
        plot(PisteValdOr.xc,PisteValdOr.yc,'k-');
        plot(PisteValdOr.xg,PisteValdOr.yg,'k-');
        plot(PisteValdOr.xd,PisteValdOr.yd,'k-');
       
        axis equal;
        grid on;
        xlabel('abscisse de Lambert');
        ylabel('ordonnée de Lambert');
            
        AffichageVoitureEKF; 
           
        if (IndicesActifs(1,6))
            % Affichage des données GPS
            hndl = plot(    Data.gps.x(Indices(1,6)-4:Indices(1,6)+2),...
                            Data.gps.y(Indices(1,6)-4:Indices(1,6)+2),'o c');         
            set(hndl,'LineWidth',1);
            % Affichage des données GPS RTK Sagitta de référence
            hndl = plot(    Data.rtk.x(Indices(1,7)-4:Indices(1,7)+2),...
                            Data.rtk.y(Indices(1,7)-4:Indices(1,7)+2),'sq- k');         
            set(hndl,'LineWidth',2);
                       
            DrawEllipse([Data.gps.x(Indices(1,6));Data.gps.y(Indices(1,6))],Q_GPS,'c',1);
        end;

        SeuilDistanceVision=25;  
        axis(   [   VehiculeNL.X_E(1)-SeuilDistanceVision VehiculeNL.X_E(1)+SeuilDistanceVision ...
                    VehiculeNL.X_E(2)-SeuilDistanceVision VehiculeNL.X_E(2)+SeuilDistanceVision]);
        
        drawnow;
        hold off;
        plot(0,0,'o w');
