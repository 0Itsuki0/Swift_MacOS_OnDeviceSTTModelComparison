
import MLX
import MLXAudioCore
import MLXAudioSTT

nonisolated class Transcriber {
    static let requiredSampleRate: Int = 16000

    private var whisper: [String: WhisperModel] = [:]
    private var qwen: [String: Qwen3ASRModel] = [:]

    init() async throws {

        for modelName in [
            "mlx-community/whisper-large-v3-turbo",
            "openai/whisper-medium", "openai/whisper-small",
        ] {
            Task {
                do {
                    let model = try await WhisperModel.fromPretrained(modelName)
                    self.whisper[modelName] = model
                    print(modelName,  " added")

                } catch {
                    print(modelName, error)
                }
            }
        }
        for modelName in [
            "mlx-community/Qwen3-ASR-1.7B-bf16",
            "mlx-community/Qwen3-ASR-1.7B-6bit",
            "mlx-community/Qwen3-ASR-0.6B-8bit",
            "mlx-community/Qwen3-ASR-0.6B-6bit",
            "mlx-community/Qwen3-ASR-0.6B-4bit",
        ] {
            Task {
                do {
                    let model = try await Qwen3ASRModel.fromPretrained(
                        modelName
                    )
                    self.qwen[modelName] = model
                    print(modelName,  " added")
                } catch {
                    print(modelName, error)
                }
            }
        }
    }

    func transcribe(_ url: URL, language: String?) throws {
        let (_, audio) = try loadAudioArray(
            from: url,
            sampleRate: Self.requiredSampleRate
        )

        Task {
            await withTaskGroup(of: Void.self) { group in
                for (name, model) in self.whisper {
                    group.addTask {
                        let output = model.generate(
                            audio: audio,
                            generationParameters: .init(language: language)
                        )
                        print("\(name): ", output)
                    }
                }

                for (name, model) in self.qwen {
                    group.addTask {
                        let output = model.generate(
                            audio: audio,
                            generationParameters: .init(language: language)
                        )
                        print("\(name): ", output)
                    }
                }

                await group.waitForAll()
            }
        }
    }
}
