package Bio::HPS::FastTrack::PipelineRun::Annotation;

# ABSTRACT: Fast track high priority samples through the Pathogen Informatics pipelines

=head1 SYNOPSIS

my $annotation_analysis_runner = Bio::HPS::FastTrack::PipelineRun::Annotation->new( database => 'virus')

=cut

use Moose;
extends('Bio::HPS::FastTrack::PipelineRun::Analysis');

sub run {

  my ($self) = @_;
  $self->_is_annotation_done();
}

sub _is_annotation_done {


}

no Moose;
__PACKAGE__->meta->make_immutable;
1;