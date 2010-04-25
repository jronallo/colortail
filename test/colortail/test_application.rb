require 'helper'

module TestColortail

  class ApplicationTest < Test::Unit::TestCase
    # No context name necessary since this is to redirect $stdout
    context "" do
      setup do
          ARGV.clear

          @stdout_orig = $stdout
          $stdout = StringIO.new
      end

      teardown do
          $stdout = @stdout_orig
      end

      context "" do
        setup do
          @stderr_orig = $stderr
          $stderr = StringIO.new
        end
        
        teardown do
          $stderr = @stderr_orig
        end
        
         should "kill all threads and exit cleanly with the word 'Terminating...'" do
           threads = Array.new
           threads.push(Thread.new { sleep }, Thread.new { sleep })
           assert_equal 2, threads.size
           assert_equal "sleep", threads[0].status
           assert_equal "sleep", threads[1].status
           begin
             ColorTail::Application.thread_cleanup(threads)
           rescue SystemExit => e
             assert_equal "Terminating...\n", $stderr.string
             assert_equal 0, e.status
           end
           assert_equal false, threads[0].status
           assert_equal false, threads[1].status
         end
      end
      
    end
    
  end

end