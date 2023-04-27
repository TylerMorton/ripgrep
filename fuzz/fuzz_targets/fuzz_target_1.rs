#![no_main]

use libfuzzer_sys::fuzz_target;


use grep::searcher::Searcher;
use grep::regex::RegexMatcher;
use grep::searcher::sinks::UTF8;

fuzz_target!(|data: &str| {

    let pattern = RegexMatcher::new(&data);
    let _ = match pattern {
        Result::Ok(matcher) => {
            let _ = Searcher::new().search_reader(
                &matcher,
                "probably need to replace this with another fuzzed value".as_bytes(),
                UTF8(|lnum, line| {
                    print!("{}:{}", lnum, line);
                    Ok(true)
                }),
            );
        },
        Err(_) => {return}
    };
});
