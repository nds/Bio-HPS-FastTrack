#!/usr/bin/env perl
use Moose;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
with 'TestHelper';

BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::PipelineRun::PanGenomeAnalysis');
  }

ok( my $pan_genome_analysis_runner = Bio::HPS::FastTrack::PipelineRun::PanGenomeAnalysis->new( study =>  2027, database => 'pathogen_prok_track_test', mode => 'prod' ), 'Creating a PanGenomeAnalysis runner object');
isa_ok ( $pan_genome_analysis_runner, 'Bio::HPS::FastTrack::PipelineRun::PanGenomeAnalysis', 'PipelineRun module hook' );
ok ( my $study = $pan_genome_analysis_runner->study_metadata(), 'Creating study object');
isa_ok ( $study, 'Bio::HPS::FastTrack::Study');
ok ( $study->lanes(), 'Collecting lanes');
isa_ok ($study->lanes()->[0], 'Bio::HPS::FastTrack::Lane');
is( $study->lanes()->[0]->study_name(), 'Comparative_RNA_seq_analysis_of_three_bacterial_species', 'Study name');
is( $study->lanes()->[0]->sample_id(), 79, 'Sample ID');
is( $study->lanes()->[0]->processed(), 15, 'Processed flag');
is( $study->lanes()->[0]->lane_name(), '7138_6#17', 'Lane name');
done_testing();
