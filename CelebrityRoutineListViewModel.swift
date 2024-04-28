import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

/// Manages the data and interactions for celebrity routines and user purchases in the app.
class CelebrityRoutineListViewModel: ObservableObject {
    @Published var celebrityRoutines: [CelebrityRoutine] = []  // List of celebrity routines fetched from Firestore.
    @Published var userPurchasedRoutineIDs: Set<String> = []  // IDs of routines the user has purchased.
    @Published var isLoading: Bool = false  // Tracks loading state.
    @Published var errorMessage: String?  // Holds error messages.

    private var db = Firestore.firestore()  // Reference to Firestore database.
    private var userId: String  // User ID of the current user.

    init(userId: String) {
        self.userId = userId
    }

    /// Fetches the list of all celebrity routines from Firestore.
    func fetchCelebrityRoutines() {
        isLoading = true
        db.collection("celebrityRoutines").getDocuments { [weak self] snapshot, error in
            self?.isLoading = false
            if let error = error {
                self?.errorMessage = "Error getting documents: \(error.localizedDescription)"
                return
            }
            guard let documents = snapshot?.documents else {
                self?.errorMessage = "No documents found in 'celebrityRoutines'"
                return
            }
            self?.celebrityRoutines = documents.compactMap { doc in
                do {
                    var routine = try doc.data(as: CelebrityRoutine.self)
                    routine.id = doc.documentID
                    return routine
                } catch {
                    self?.errorMessage = "Failed to decode routine for document with ID: \(doc.documentID)"
                    return nil
                }
            }
            DispatchQueue.main.async {
                self?.objectWillChange.send()
            }
        }
    }

    /// Fetches the list of routines the user has purchased.
    func fetchUserPurchases() {
        isLoading = true
        db.collection("purchases")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { [weak self] snapshot, error in
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Error getting user purchases: \(error.localizedDescription)"
                    return
                }

                let purchaseIds = snapshot?.documents.compactMap { document -> String? in
                    document.data()["routineId"] as? String
                } ?? []

                self?.userPurchasedRoutineIDs = Set(purchaseIds)
            }
    }

    /// Attempts to purchase a routine and save it in the Firestore database.
    func purchaseRoutine(_ routine: CelebrityRoutine) {
        let purchase = CelebrityRoutinePurchase(userId: userId, routineId: routine.id, purchaseDate: Date().timeIntervalSince1970)
        do {
            try db.collection("purchases").document("\(userId)_\(routine.id)").setData(from: purchase) {
                error in
                if let error = error {
                    self.errorMessage = "Error saving purchase: \(error.localizedDescription)"
                } else {
                    print("Purchase saved successfully")
                    self.userPurchasedRoutineIDs.insert(routine.id)
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                }
            }
        } catch let error {
            errorMessage = "Error saving purchase: \(error.localizedDescription)"
        }
    }

    /// Checks if a specific routine has been purchased by the user.
    func isPurchased(_ routine: CelebrityRoutine) -> Bool {
        return userPurchasedRoutineIDs.contains(routine.id)
    }

    /// Adds a task to a routine in the Firestore collection.
    func addTask(to routineId: String, task: RoutineTask) {
        guard let taskData = try? JSONEncoder().encode(task),
              let taskDictionary = try? JSONSerialization.jsonObject(with: taskData) as? [String: Any] else {
            print("Error encoding task data")
            return
        }
        
        db.collection("celebrityRoutines").document(routineId).updateData([
            "tasks": FieldValue.arrayUnion([taskDictionary])
        ]) { error in
            if let error = error {
                print("Error adding task: \(error)")
                self.errorMessage = "Error adding task: \(error.localizedDescription)"
            } else {
                print("Task added successfully")
            }
        }
    }
}
