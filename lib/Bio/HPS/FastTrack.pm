package Bio::HPS::FastTrack;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $hps_fast_track_bacteria_mapping_and_rna_seq =  Bio::HPS::FastTrack->new( study => '4562', database => 'bacteria', pipeline => ['mapping','rna-seq'] );
$hps_fast_track_bacteria_mapping_and_rna_seq->study();
$hps_fast_track_bacteria_mapping_and_rna_seq->database();
for my $pipeline_run( @{ hps_fast_track_bacteria_mapping_and_rna_seq->pipeline_runners() } ) {
  $pipeline_run->run();
}

=cut

use Moose;
use Bio::HPS::FastTrack::SetPipeline;
use Bio::HPS::FastTrack::Exception;
use Bio::HPS::FastTrack::Types::FastTrackTypes;

has 'study' => ( is => 'rw', isa => 'Int', lazy => 1, default => 'NA');
has 'lane' => ( is => 'rw', isa => 'Str', lazy => 1, default => 'NA');
has 'database'   => ( is => 'rw', isa => 'Str', required => 1 );
has 'pipeline'   => ( is => 'rw',  isa => 'Maybe[ArrayRef]', default => sub { [] });
has 'pipeline_runners'   => ( is => 'rw', isa => 'ArrayRef', lazy => 1, builder => '_build_pipeline_runners');
has 'mode'   => ( is => 'rw', isa => 'RunMode', required => 1 );

sub run {

  my ($self) = @_;

  if ( defined $self->lane && $self->study eq 'NA' ) {
    for my $pipeline_runner(@{$self->pipeline_runners()}) {
      $pipeline_runner->study_metadata();
      $pipeline_runner->run();
    }
  }
  if ( defined $self->study && $self->lane eq 'NA' ) {
    for my $pipeline_runner(@{$self->pipeline_runners()}) {
      $pipeline_runner->study_metadata();
      $pipeline_runner->run();
      $pipeline_runner->config_data();
      $pipeline_runner->config_data->path_to_high_level_config();
      $pipeline_runner->config_data->path_to_low_level_config();
    }
  }


}

sub _build_pipeline_runners {
  my ($self) = @_;
  return Bio::HPS::FastTrack::SetPipeline->new( study => $self->study(), lane => $self->lane(), pipeline => $self->pipeline(), database=> $self->database(), mode => $self->mode )->pipeline_runners();
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

