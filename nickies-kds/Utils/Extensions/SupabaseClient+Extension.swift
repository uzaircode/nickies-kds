//
//  SupabaseClient+Extension.swift
//  nickies-kds
//
//  Created by Nik Uzair on 27/10/2024.
//

import Foundation
import Supabase


extension SupabaseClient {
  static var development: SupabaseClient {
    SupabaseClient(supabaseURL: URL(string: "https://hchoebjpdjwuypyjytvd.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhjaG9lYmpwZGp3dXlweWp5dHZkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk5MzY1NzUsImV4cCI6MjA0NTUxMjU3NX0.gYmU3DP1rHtS4IyejZ3r6rWKxGpmt3ZeitBOwbgmY84")
  }
}
