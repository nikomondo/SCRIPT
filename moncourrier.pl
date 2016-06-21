 #!/usr/bin/perl -w

    use strict;
    use Getopt::Long;
    use Net::SMTP;

    my %opt;

    # Définition des options
    # 'corps' pour le message lui-même
    # 'liste' pour la liste des destinataires
    GetOptions(\%opt, "corps", "liste")
      or die "Options: --corps <fichier> --liste <fichier CSV>\n";

    # les en-têtes concaténées en une seule chaîne
    my $head = join "", <DATA>;

    # ouverture du fichier contenant le message
    # et stockage du message dans une chaîne
    open LIRE_CORPS,  $opt{corps} or die "ne peut ouvrir corps $!\n";
    my $body = join "", <LIRE_CORPS>;
    close LIRE_CORPS;

    # initialisation de la table contenant les champs du fichier liste.csv
    my @field = ("GENRE",
                 "NOM",
                 "PRENOM",
                 "ADRESSE");

    open LIRE_LISTE, $opt{liste} or die "Ne peut ouvrir liste: $!\n";

    while(<LIRE_LISTE>) {
        chomp;
       
        my @id = split/\t/;
        my %replace;
        @replace{@field} = @id;
        
        my $current_head = $head;
        $current_head =~ s/<<([A-Z]+)>>/$replace{$1}/sg;
        my $message = $current_head.$body;
        
        my $smtp = Net::SMTP->new("smtp.monfai.com", Debug => 1) 
          or die "Pas de connexion SMTP: $!\n";
        $smtp->mail('president@monassoce.org')
          or die "Erreur: MAIL FROM\n";
        $smtp->to($replace{ADRESSE})
          or die "Erreur: RCPT TO\n";
        $smtp->data()
          or die "Erreur: DATA\n";
        $smtp->datasend($message)
          or die "Impossible d'envoyer le message\n";
        $smtp->dataend()
          or die "Erreur (fin de DATA)\n";
        $smtp->quit()
          or die "Erreur: QUIT\n";
    }

    close LIRE_LISTE;

    __DATA__
    To: <<NOM>> <<PRENOM>><<<ADRESSE>>>
    From: La présidence <president@monassoce.org>
    Subject: lettre mensuelle d'information
    X-Mailer: moncourriel.pl v0.1
    Reply-To: La présidence <president@monassoce.org>


    Bonjour <<GENRE>> <<NOM>>,
