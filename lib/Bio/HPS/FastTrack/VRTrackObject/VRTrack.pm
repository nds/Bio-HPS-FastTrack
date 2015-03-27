package Bio::HPS::FastTrack::VRTrackObject::VRTrack;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $hps_lane = Bio::HPS::FastTrack::VRTrackObject::Lane->new(lane_name => $name, sample_id => $sample_id, processed => $processed_flag});

=cut

use Moose;
use DBI;
use VRTrack::Lane;
use Bio::HPS::FastTrack::Types::FastTrackTypes;

has 'database' => ( is => 'rw', isa => 'Str', required => 1 );
has 'mode' => ( is => 'rw', isa => 'RunMode', required => 1 );
has 'hostname' => ( is => 'rw', isa => 'Str', lazy => 1, default => 'mcs11' ); #Test database at the moment, when in production change to 'mcs17'
has 'port' => ( is => 'rw', isa => 'Int', lazy => 1, default => '3346' ); #Test port at the moment, when in production change to '3347'
has 'user' => ( is => 'rw', isa => 'Str', lazy => 1, default => 'pathpipe_ro' );
has 'vrtrack' => ( is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_vrtrack_instance' );


sub _build_vrtrack_instance {

  my ($self) = @_;
  #my $vrtrack = VRTrack::VRTrack->new();

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

  return \%vrtrack;

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
