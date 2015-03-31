package Bio::HPS::FastTrack::VRTrackWrapper::VRTrack;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $hps_vrtrack = Bio::HPS::FastTrack::VRTrackWrapper::VRTrack->new(host => 'host', => port => 'port', database => 'database', user => 'user');

=cut

use Moose;
use lib "/software/pathogen/internal/pathdev/vr-codebase/modules";
use DBI;
use VRTrack::VRTrack;
use VRTrack::Lane;
use Bio::HPS::FastTrack::Types::FastTrackTypes;


has 'database' => ( is => 'rw', isa => 'Str', required => 1 );
has 'mode' => ( is => 'rw', isa => 'RunMode', required => 1 );
has 'hostname' => ( is => 'rw', isa => 'Str', lazy => 1, default => 'mcs11' ); #Test database at the moment, when in production change to 'mcs17'
has 'port' => ( is => 'rw', isa => 'Int', lazy => 1, default => '3346' ); #Test port at the moment, when in production change to '3347'
has 'user' => ( is => 'rw', isa => 'Str', lazy => 1, default => 'pathpipe_ro' );
has 'vrtrack' => ( is => 'rw', isa => 'VRTrack::VRTrack', lazy => 1, builder => '_build_vrtrack_instance' );

sub _build_vrtrack_instance {

  my ($self) = @_;

  my %db_params = (
		    host => $self->hostname,
		    port => $self->port,
		    database => $self->database,
		    user => $self->user,
		    password => ''
		   );
  my $vrtrack = VRTrack::VRTrack->new(\%db_params);

  return $vrtrack;
}


sub _mock_vrtrack {

  my ($self) = @_;

  my $dbh = _dbh($self);
  my %vrtrack = (
		 '_db_params' => {
				  host => $self->hostname,
				  port => $self->port,
				  database => $self->database,
				  user => $self->user,
				  password => ''
			     },
		 '_dbh' => $dbh,
		 'transaction' => 0
	    );

  return \%vrtrack; # returns hashref and not a true VRTrack::VRTrack object
}


sub _dbh {
  my ($self) = @_;
  my $dbi_driver = $self->mode() eq 'prod' ? 'DBI:mysql:database=' : 'DBI:SQLite:dbname=';
  my $dsn = $dbi_driver . $self->database() . ';host=' . $self->hostname() . ';port=' . $self->port();
  my $dbh = DBI->connect($dsn, $self->user()) ||
    Bio::HPS::FastTrack::Exception::DatabaseConnection->throw(
							      error => "Error: Could not connect to database '" .
							      $self->database() . "' on host '" .
							      $self->hostname . "' on port '" . $self->port . "'\n"
							     );
  return $dbh;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
